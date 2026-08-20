package com.dyota.auth.verification;

import com.dyota.auth.config.AuthProperties;
import com.dyota.auth.otp.delivery.OtpDispatcher;
import com.dyota.auth.otp.domain.OtpIssue;
import com.dyota.auth.otp.domain.OtpStatus;
import com.dyota.auth.otp.repository.OtpIssueRepository;
import com.dyota.auth.otp.service.OtpGenerator;
import com.dyota.auth.ratelimit.RateLimiter;
import com.dyota.auth.ratelimit.RateScope;
import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.session.domain.SessionStatus;
import com.dyota.auth.session.domain.TerminationReason;
import com.dyota.auth.session.domain.VerificationSession;
import com.dyota.auth.session.repository.VerificationSessionRepository;
import com.dyota.auth.support.AuthServiceException;
import com.dyota.auth.support.Identifiers;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

/**
 * The single transactional owner of the verification lifecycle.
 *
 * <p>Send, resend and verify all mutate the same aggregate (a session plus its one live
 * code), so they live together: splitting them across services would put the cooldown
 * check and the counter increment in different transactions, which is exactly the race
 * this class exists to prevent.
 */
@Service
public class VerificationService {

    private static final Logger log = LoggerFactory.getLogger(VerificationService.class);

    private final VerificationSessionRepository sessions;
    private final OtpIssueRepository otps;
    private final OtpGenerator generator;
    private final OtpDispatcher dispatcher;
    private final RateLimiter rateLimiter;
    private final AuthProperties properties;
    private final Clock clock;

    public VerificationService(
            VerificationSessionRepository sessions,
            OtpIssueRepository otps,
            OtpGenerator generator,
            OtpDispatcher dispatcher,
            RateLimiter rateLimiter,
            AuthProperties properties,
            Clock clock) {
        this.sessions = sessions;
        this.otps = otps;
        this.generator = generator;
        this.dispatcher = dispatcher;
        this.rateLimiter = rateLimiter;
        this.properties = properties;
        this.clock = clock;
    }

    // ---------------------------------------------------------------- send

    @Transactional
    public SendResult send(
            String rawIdentifier,
            IdentifierType type,
            Purpose purpose,
            UUID userId,
            String clientIp) {

        String identifier = Identifiers.normalise(rawIdentifier, type);
        if (!Identifiers.isValid(identifier, type)) {
            throw AuthServiceException.badRequest("INVALID_IDENTIFIER",
                    "Identifier is not a valid " + type);
        }

        // Checked before anything is persisted: accepting a login for a channel we cannot
        // deliver on would return a session id for a code that never arrives.
        if (!dispatcher.canDeliver(type)) {
            throw new AuthServiceException("CHANNEL_UNAVAILABLE",
                    org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE,
                    "Verification by " + type + " is not available");
        }

        Instant now = clock.instant();
        enforceSendBudget(identifier, clientIp, now);

        AuthProperties.Otp otpConfig = properties.getOtp();
        VerificationSession session = VerificationSession.start(
                identifier, type, purpose, userId, clientIp,
                now, now.plus(properties.getSession().getTtl()));
        session.recordSend(now);
        sessions.save(session);

        String code = generator.generate(otpConfig.getLength());
        OtpIssue otp = OtpIssue.issue(session.getId(), code, now, now.plus(otpConfig.getTtl()));
        otps.save(otp);

        dispatchAfterCommit(identifier, type, code, purpose);

        log.info("Started verification session {} for {} ({})",
                session.getId(), Identifiers.mask(identifier), type);

        return new SendResult(
                session.getId(),
                session.getExpiresAt(),
                otp.getExpiresAt(),
                now.plus(otpConfig.getResendCooldown()),
                sendsRemaining(session));
    }

    // -------------------------------------------------------------- resend

    @Transactional
    public ResendResult resend(UUID sessionId) {
        Instant now = clock.instant();
        VerificationSession session = lockUsableSession(sessionId, now);
        AuthProperties.Otp otpConfig = properties.getOtp();

        // Cooldown and the send-count check must both sit inside this locked window,
        // or two simultaneous taps each observe the pre-increment state and both pass.
        if (session.getLastSentAt() != null) {
            Instant available = session.getLastSentAt().plus(otpConfig.getResendCooldown());
            if (now.isBefore(available)) {
                throw AuthServiceException.tooManyRequests("COOLDOWN_ACTIVE",
                        "Wait before requesting another code",
                        Duration.between(now, available));
            }
        }

        if (session.getSendCount() >= otpConfig.getMaxSendsPerSession()) {
            session.terminate(TerminationReason.SENDS_EXHAUSTED, now);
            finalise(session, now);
            throw AuthServiceException.tooManyRequests("SENDS_EXHAUSTED",
                    "No further codes may be sent for this session", null);
        }

        Optional<OtpIssue> active = otps.findBySessionIdAndStatus(sessionId, OtpStatus.ACTIVE);
        String code;
        OtpIssue otp;
        boolean newCodeIssued;

        if (active.isEmpty() || active.get().isExpiredAt(now)) {
            // The one place the "same code" rule has to yield: a dead code cannot be
            // safely revived, so we supersede it and issue a fresh one. The partial
            // unique index forces the UPDATE to land before the INSERT.
            active.ifPresent(existing -> {
                existing.supersede();
                otps.saveAndFlush(existing);
            });
            code = generator.generate(otpConfig.getLength());
            otp = OtpIssue.issue(sessionId, code, now, now.plus(otpConfig.getTtl()));
            otps.save(otp);
            newCodeIssued = true;
        } else {
            otp = active.get();
            code = otp.getCode();
            otp.recordResend(now);
            if (otpConfig.isExtendTtlOnResend()) {
                otp.extendExpiry(now.plus(otpConfig.getTtl()));
            }
            otps.save(otp);
            newCodeIssued = false;
        }

        session.recordSend(now);
        dispatchAfterCommit(session.getIdentifier(), session.getIdentifierType(), code,
                session.getPurpose());

        log.info("Resent code for session {} (newCode={}, send {} of {})",
                sessionId, newCodeIssued, session.getSendCount(), otpConfig.getMaxSendsPerSession());

        return new ResendResult(
                now.plus(otpConfig.getResendCooldown()),
                otp.getExpiresAt(),
                sendsRemaining(session),
                newCodeIssued);
    }

    // -------------------------------------------------------------- verify

    @Transactional
    public VerificationOutcome verify(UUID sessionId, String submittedCode) {
        Instant now = clock.instant();
        VerificationSession session = sessions.findByIdForUpdate(sessionId)
                .orElseThrow(AuthServiceException::notFound);

        // Idempotent replay: a client retrying after a network timeout resubmits the
        // same code, and should get the same answer rather than a confusing failure.
        if (session.getStatus() == SessionStatus.VERIFIED) {
            boolean sameCode = otps.findBySessionIdAndStatus(sessionId, OtpStatus.CONSUMED)
                    .map(consumed -> consumed.matches(submittedCode))
                    .orElse(false);
            return sameCode
                    ? VerificationOutcome.success(session.getUserId(), session.getIdentifier(),
                            session.getIdentifierType(), session.getLoginTime())
                    : VerificationOutcome.failure("ALREADY_VERIFIED", 0);
        }

        if (session.getStatus() == SessionStatus.LOCKED) {
            return VerificationOutcome.failure("ATTEMPTS_EXHAUSTED", 0);
        }
        if (session.getStatus().isTerminal() || session.isExpiredAt(now)) {
            if (!session.getStatus().isTerminal()) {
                session.terminate(TerminationReason.EXPIRED, now);
                finalise(session, now);
            }
            return VerificationOutcome.failure("SESSION_EXPIRED", 0);
        }

        AuthProperties.Otp otpConfig = properties.getOtp();
        int attemptsRemaining = otpConfig.getMaxVerifyAttempts() - session.getVerifyAttempts();
        if (attemptsRemaining <= 0) {
            session.terminate(TerminationReason.ATTEMPTS_EXHAUSTED, now);
            finalise(session, now);
            return VerificationOutcome.failure("ATTEMPTS_EXHAUSTED", 0);
        }

        Optional<OtpIssue> active = otps.findBySessionIdAndStatus(sessionId, OtpStatus.ACTIVE);
        if (active.isEmpty() || active.get().isExpiredAt(now)) {
            active.ifPresent(expired -> {
                expired.expire();
                otps.save(expired);
            });
            return VerificationOutcome.failure("CODE_EXPIRED", attemptsRemaining);
        }

        OtpIssue otp = active.get();
        if (!otp.matches(submittedCode)) {
            session.recordFailedAttempt();
            int left = otpConfig.getMaxVerifyAttempts() - session.getVerifyAttempts();
            if (left <= 0) {
                session.terminate(TerminationReason.ATTEMPTS_EXHAUSTED, now);
                finalise(session, now);
                log.info("Session {} locked after {} failed attempts",
                        sessionId, session.getVerifyAttempts());
                return VerificationOutcome.failure("ATTEMPTS_EXHAUSTED", 0);
            }
            return VerificationOutcome.failure("INVALID_CODE", left);
        }

        otp.consume(now);
        otps.save(otp);
        session.markVerified(now);

        String identifier = session.getIdentifier();
        IdentifierType type = session.getIdentifierType();
        UUID userId = session.getUserId();
        finalise(session, now);

        log.info("Session {} verified for {}", sessionId, Identifiers.mask(identifier));
        return VerificationOutcome.success(userId, identifier, type, now);
    }

    // ----------------------------------------------------------- lifecycle

    @Transactional
    public void terminate(UUID sessionId) {
        Instant now = clock.instant();
        sessions.findByIdForUpdate(sessionId).ifPresent(session -> {
            session.terminate(TerminationReason.CLIENT_TERMINATED, now);
            // An explicit termination is an explicit request to forget, so it deletes
            // immediately regardless of the retention grace window.
            sessions.delete(session);
            log.info("Session {} terminated by caller", sessionId);
        });
    }

    @Transactional(readOnly = true)
    public SessionStatusView status(UUID sessionId) {
        VerificationSession session = sessions.findById(sessionId)
                .orElseThrow(AuthServiceException::notFound);
        AuthProperties.Otp otpConfig = properties.getOtp();
        Instant resendAvailableAt = session.getLastSentAt() == null
                ? null
                : session.getLastSentAt().plus(otpConfig.getResendCooldown());
        return new SessionStatusView(
                session.getId(),
                session.getStatus(),
                session.getIdentifierType(),
                session.getPurpose(),
                Identifiers.mask(session.getIdentifier()),
                session.getSendCount(),
                sendsRemaining(session),
                session.getVerifyAttempts(),
                Math.max(0, otpConfig.getMaxVerifyAttempts() - session.getVerifyAttempts()),
                session.getCreatedAt(),
                session.getExpiresAt(),
                resendAvailableAt,
                session.getLoginTime());
    }

    // ------------------------------------------------------------- helpers

    private VerificationSession lockUsableSession(UUID sessionId, Instant now) {
        VerificationSession session = sessions.findByIdForUpdate(sessionId)
                .orElseThrow(AuthServiceException::notFound);
        if (session.getStatus().isTerminal()) {
            throw AuthServiceException.conflict("SESSION_TERMINATED",
                    "This session is already finished");
        }
        if (session.isExpiredAt(now)) {
            session.terminate(TerminationReason.EXPIRED, now);
            finalise(session, now);
            throw AuthServiceException.conflict("SESSION_EXPIRED", "This session has expired");
        }
        return session;
    }

    private void enforceSendBudget(String identifier, String clientIp, Instant now) {
        AuthProperties.RateLimit limits = properties.getRateLimit();
        if (!rateLimiter.tryConsume(RateScope.IDENTIFIER, identifier,
                limits.getPerIdentifierSends(), now)) {
            log.warn("Identifier rate limit hit for {}", Identifiers.mask(identifier));
            throw AuthServiceException.tooManyRequests("IDENTIFIER_RATE_LIMITED",
                    "Too many codes requested for this identifier", rateLimiter.retryAfter(now));
        }
        if (!rateLimiter.tryConsume(RateScope.IP, clientIp, limits.getPerIpSends(), now)) {
            log.warn("IP rate limit hit for {}", clientIp);
            throw AuthServiceException.tooManyRequests("IP_RATE_LIMITED",
                    "Too many codes requested from this address", rateLimiter.retryAfter(now));
        }
    }

    private int sendsRemaining(VerificationSession session) {
        return Math.max(0, properties.getOtp().getMaxSendsPerSession() - session.getSendCount());
    }

    /**
     * Applies the retention policy to a terminated session. With retention at zero the
     * row (and its cascaded codes) goes now; otherwise the sweeper collects it after the
     * grace window, which is what keeps idempotent retries working.
     */
    private void finalise(VerificationSession session, Instant now) {
        if (properties.getSession().getPostTerminalRetention().isZero()) {
            sessions.delete(session);
        }
    }

    /**
     * Delivery happens only once the transaction has committed, so a rollback can never
     * leave a real message in a user's inbox. The inverse failure — committed session,
     * failed delivery — is recoverable by the caller through resend.
     */
    private void dispatchAfterCommit(
            String identifier, IdentifierType type, String code, Purpose purpose) {
        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            dispatcher.dispatch(identifier, type, code, purpose);
            return;
        }
        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCommit() {
                try {
                    dispatcher.dispatch(identifier, type, code, purpose);
                } catch (RuntimeException e) {
                    log.error("Failed to deliver code to {}: {}",
                            Identifiers.mask(identifier), e.getMessage());
                }
            }
        });
    }
}
