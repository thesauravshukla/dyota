package com.dyota.auth.verification;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.dyota.auth.AbstractIntegrationTest;
import com.dyota.auth.cleanup.SessionCleaner;
import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.support.AuthServiceException;
import com.dyota.auth.testsupport.MutableClock;
import com.dyota.auth.testsupport.RecordingOtpSender;
import java.time.Duration;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.TestPropertySource;

@TestPropertySource(properties = {
        "auth.otp.resend-cooldown=PT30S",
        "auth.otp.max-sends-per-session=3",
        "auth.otp.max-verify-attempts=3",
        "auth.otp.ttl=PT5M",
        "auth.session.ttl=PT15M",
        "auth.session.post-terminal-retention=PT60S",
        "auth.rate-limit.per-identifier-sends=100",
        "auth.rate-limit.per-ip-sends=100"
})
class VerificationFlowIntegrationTest extends AbstractIntegrationTest {

    @Autowired
    VerificationService verification;
    @Autowired
    RecordingOtpSender sender;
    @Autowired
    MutableClock clock;
    @Autowired
    JdbcTemplate jdbc;
    @Autowired
    SessionCleaner cleaner;

    @BeforeEach
    void reset() {
        jdbc.update("DELETE FROM verification_session");
        jdbc.update("DELETE FROM rate_counter");
        sender.clear();
    }

    private SendResult send() {
        return verification.send("+919876543210", IdentifierType.PHONE, Purpose.LOGIN,
                null, "203.0.113.9");
    }

    @Test
    void sendThenVerifyCompletesTheHappyPath() {
        SendResult sent = send();
        assertThat(sender.count()).isEqualTo(1);
        assertThat(sent.sendsRemaining()).isEqualTo(2);

        VerificationOutcome outcome = verification.verify(sent.sessionId(), sender.lastCode());

        assertThat(outcome.verified()).isTrue();
        assertThat(outcome.canLogin()).isTrue();
        assertThat(outcome.identifier()).isEqualTo("+919876543210");
    }

    @Test
    void resendDeliversTheIdenticalCode() {
        SendResult sent = send();
        String first = sender.lastCode();

        clock.advance(Duration.ofSeconds(31));
        ResendResult resend = verification.resend(sent.sessionId());

        assertThat(resend.newCodeIssued()).isFalse();
        assertThat(sender.lastCode()).isEqualTo(first);
        assertThat(sender.count()).isEqualTo(2);
        assertThat(resend.sendsRemaining()).isEqualTo(1);
        // The original code still verifies after being resent.
        assertThat(verification.verify(sent.sessionId(), first).verified()).isTrue();
    }

    @Test
    void resendWithinCooldownIsRejected() {
        SendResult sent = send();
        clock.advance(Duration.ofSeconds(29));

        assertThatThrownBy(() -> verification.resend(sent.sessionId()))
                .isInstanceOf(AuthServiceException.class)
                .extracting(e -> ((AuthServiceException) e).getCode())
                .isEqualTo("COOLDOWN_ACTIVE");
        assertThat(sender.count()).isEqualTo(1);
    }

    @Test
    void resendIsAllowedExactlyOnTheCooldownBoundary() {
        SendResult sent = send();
        clock.advance(Duration.ofSeconds(30));
        assertThat(verification.resend(sent.sessionId()).newCodeIssued()).isFalse();
    }

    @Test
    void sendsAreCappedPerSession() {
        SendResult sent = send();
        clock.advance(Duration.ofSeconds(31));
        verification.resend(sent.sessionId());
        clock.advance(Duration.ofSeconds(31));
        verification.resend(sent.sessionId());

        clock.advance(Duration.ofSeconds(31));
        assertThatThrownBy(() -> verification.resend(sent.sessionId()))
                .isInstanceOf(AuthServiceException.class)
                .extracting(e -> ((AuthServiceException) e).getCode())
                .isEqualTo("SENDS_EXHAUSTED");
        assertThat(sender.count()).isEqualTo(3);
    }

    @Test
    void expiredCodeIsReplacedRatherThanRevived() {
        SendResult sent = send();
        String original = sender.lastCode();

        clock.advance(Duration.ofMinutes(6));
        ResendResult resend = verification.resend(sent.sessionId());

        assertThat(resend.newCodeIssued()).isTrue();
        assertThat(sender.lastCode()).isNotEqualTo(original);
        assertThat(verification.verify(sent.sessionId(), original).reason())
                .isEqualTo("INVALID_CODE");
    }

    @Test
    void resendDoesNotExtendTheCodesLifetime() {
        SendResult sent = send();
        clock.advance(Duration.ofSeconds(31));
        ResendResult resend = verification.resend(sent.sessionId());

        assertThat(resend.otpExpiresAt()).isEqualTo(sent.otpExpiresAt());
    }

    @Test
    void wrongCodesCountDownThenLockTheSession() {
        SendResult sent = send();

        assertThat(verification.verify(sent.sessionId(), "000000").attemptsRemaining()).isEqualTo(2);
        assertThat(verification.verify(sent.sessionId(), "000001").attemptsRemaining()).isEqualTo(1);

        VerificationOutcome third = verification.verify(sent.sessionId(), "000002");
        assertThat(third.reason()).isEqualTo("ATTEMPTS_EXHAUSTED");

        // Even the correct code is refused once the session has locked.
        assertThat(verification.verify(sent.sessionId(), sender.lastCode()).verified()).isFalse();
    }

    @Test
    void verifyIsIdempotentForARetriedRequest() {
        SendResult sent = send();
        String code = sender.lastCode();

        assertThat(verification.verify(sent.sessionId(), code).verified()).isTrue();
        assertThat(verification.verify(sent.sessionId(), code).verified()).isTrue();
    }

    @Test
    void aSessionNeverHoldsMoreThanOneLiveCode() {
        SendResult sent = send();
        clock.advance(Duration.ofMinutes(6));
        verification.resend(sent.sessionId());

        Integer active = jdbc.queryForObject(
                "SELECT count(*) FROM otp_issue WHERE session_id = ? AND status = 'ACTIVE'",
                Integer.class, sent.sessionId());
        assertThat(active).isEqualTo(1);
    }

    @Test
    void terminatingASessionRemovesItAndItsCodes() {
        SendResult sent = send();
        verification.terminate(sent.sessionId());

        assertThat(countSessions()).isZero();
        assertThat(countOtps()).as("codes cascade with the session").isZero();
    }

    @Test
    void sweepClearsSessionsOnceTheRetentionWindowPasses() {
        SendResult sent = send();
        verification.verify(sent.sessionId(), sender.lastCode());

        // Still present during the grace window that keeps retries meaningful.
        assertThat(countSessions()).isEqualTo(1);

        clock.advance(Duration.ofSeconds(61));
        cleaner.sweep();

        assertThat(countSessions()).isZero();
        assertThat(countOtps()).isZero();
    }

    @Test
    void sweepCollectsAbandonedSessions() {
        send();
        clock.advance(Duration.ofMinutes(16));
        cleaner.sweep();

        assertThat(countSessions()).isZero();
    }

    @Test
    void unknownSessionIsReportedNotFound() {
        assertThatThrownBy(() -> verification.resend(UUID.randomUUID()))
                .isInstanceOf(AuthServiceException.class)
                .extracting(e -> ((AuthServiceException) e).getCode())
                .isEqualTo("SESSION_NOT_FOUND");
    }

    @Test
    void malformedIdentifierIsRejectedBeforeAnythingIsStored() {
        assertThatThrownBy(() -> verification.send("not-a-phone", IdentifierType.PHONE,
                Purpose.LOGIN, null, "203.0.113.9"))
                .isInstanceOf(AuthServiceException.class)
                .extracting(e -> ((AuthServiceException) e).getCode())
                .isEqualTo("INVALID_IDENTIFIER");
        assertThat(countSessions()).isZero();
    }

    private Integer countSessions() {
        return jdbc.queryForObject("SELECT count(*) FROM verification_session", Integer.class);
    }

    private Integer countOtps() {
        return jdbc.queryForObject("SELECT count(*) FROM otp_issue", Integer.class);
    }
}
