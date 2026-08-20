package com.dyota.auth.session.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import java.time.Instant;
import java.util.UUID;

/**
 * A single verification attempt against one contact point.
 *
 * <p>This is the only place user data lives in this service, and it lives here for
 * minutes. There is no users table: once the session terminates the row is deleted
 * and the service retains nothing about who logged in.
 */
@Entity
@Table(name = "verification_session")
public class VerificationSession {

    @Id
    private UUID id;

    @Column(nullable = false, length = 320)
    private String identifier;

    @Enumerated(EnumType.STRING)
    @Column(name = "identifier_type", nullable = false, length = 16)
    private IdentifierType identifierType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private Purpose purpose;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private SessionStatus status;

    /** Opaque passthrough from the caller. Never resolved or looked up here. */
    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "send_count", nullable = false)
    private int sendCount;

    @Column(name = "verify_attempts", nullable = false)
    private int verifyAttempts;

    @Column(name = "last_sent_at")
    private Instant lastSentAt;

    @Column(name = "login_time")
    private Instant loginTime;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    @Column(name = "terminated_at")
    private Instant terminatedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "termination_reason", length = 32)
    private TerminationReason terminationReason;

    @Column(name = "client_ip", length = 45)
    private String clientIp;

    @Version
    private long version;

    protected VerificationSession() {
        // for JPA
    }

    public static VerificationSession start(
            String identifier,
            IdentifierType identifierType,
            Purpose purpose,
            UUID userId,
            String clientIp,
            Instant now,
            Instant expiresAt) {
        VerificationSession s = new VerificationSession();
        s.id = UUID.randomUUID();
        s.identifier = identifier;
        s.identifierType = identifierType;
        s.purpose = purpose;
        s.status = SessionStatus.PENDING;
        s.userId = userId;
        s.clientIp = clientIp;
        s.createdAt = now;
        s.expiresAt = expiresAt;
        s.sendCount = 0;
        s.verifyAttempts = 0;
        return s;
    }

    /** A session past its expiry is treated as expired even before the sweeper reaches it. */
    public boolean isExpiredAt(Instant now) {
        return now.isAfter(expiresAt);
    }

    public boolean isUsableAt(Instant now) {
        return status == SessionStatus.PENDING && !isExpiredAt(now);
    }

    public void recordSend(Instant now) {
        this.sendCount++;
        this.lastSentAt = now;
    }

    public void recordFailedAttempt() {
        this.verifyAttempts++;
    }

    public void markVerified(Instant now) {
        this.status = SessionStatus.VERIFIED;
        this.loginTime = now;
        terminate(TerminationReason.VERIFIED, now);
    }

    public void terminate(TerminationReason reason, Instant now) {
        if (this.status == SessionStatus.PENDING) {
            this.status = switch (reason) {
                case VERIFIED -> SessionStatus.VERIFIED;
                case EXPIRED -> SessionStatus.EXPIRED;
                case ATTEMPTS_EXHAUSTED, SENDS_EXHAUSTED -> SessionStatus.LOCKED;
                case CLIENT_TERMINATED -> SessionStatus.EXPIRED;
            };
        }
        this.terminationReason = reason;
        this.terminatedAt = now;
    }

    public UUID getId() {
        return id;
    }

    public String getIdentifier() {
        return identifier;
    }

    public IdentifierType getIdentifierType() {
        return identifierType;
    }

    public Purpose getPurpose() {
        return purpose;
    }

    public SessionStatus getStatus() {
        return status;
    }

    public UUID getUserId() {
        return userId;
    }

    public int getSendCount() {
        return sendCount;
    }

    public int getVerifyAttempts() {
        return verifyAttempts;
    }

    public Instant getLastSentAt() {
        return lastSentAt;
    }

    public Instant getLoginTime() {
        return loginTime;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getExpiresAt() {
        return expiresAt;
    }

    public Instant getTerminatedAt() {
        return terminatedAt;
    }

    public TerminationReason getTerminationReason() {
        return terminationReason;
    }

    public String getClientIp() {
        return clientIp;
    }
}
