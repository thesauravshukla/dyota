package com.dyota.auth.otp.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.UUID;

/**
 * One issued code, owned by one session.
 *
 * <p>The code is stored in plaintext by explicit design decision. It is mitigated by a
 * short TTL and by {@code ON DELETE CASCADE} from the session, so codes never outlive
 * the verification they belong to. Encrypting this column later touches only OtpService
 * and one migration.
 */
@Entity
@Table(name = "otp_issue")
public class OtpIssue {

    @Id
    private UUID id;

    @Column(name = "session_id", nullable = false)
    private UUID sessionId;

    @Column(nullable = false, length = 10)
    private String code;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private OtpStatus status;

    @Column(name = "send_count", nullable = false)
    private int sendCount;

    @Column(name = "issued_at", nullable = false)
    private Instant issuedAt;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    @Column(name = "last_sent_at", nullable = false)
    private Instant lastSentAt;

    @Column(name = "consumed_at")
    private Instant consumedAt;

    protected OtpIssue() {
        // for JPA
    }

    public static OtpIssue issue(UUID sessionId, String code, Instant now, Instant expiresAt) {
        OtpIssue o = new OtpIssue();
        o.id = UUID.randomUUID();
        o.sessionId = sessionId;
        o.code = code;
        o.status = OtpStatus.ACTIVE;
        o.sendCount = 1;
        o.issuedAt = now;
        o.expiresAt = expiresAt;
        o.lastSentAt = now;
        return o;
    }

    public boolean isExpiredAt(Instant now) {
        return now.isAfter(expiresAt);
    }

    /**
     * Constant-time comparison, so a timing side channel cannot be used to recover the
     * code digit by digit.
     */
    public boolean matches(String candidate) {
        if (candidate == null) {
            return false;
        }
        return MessageDigest.isEqual(
                code.getBytes(StandardCharsets.UTF_8),
                candidate.getBytes(StandardCharsets.UTF_8));
    }

    /** Re-dispatch of the same code. Deliberately does not touch {@code expiresAt}. */
    public void recordResend(Instant now) {
        this.sendCount++;
        this.lastSentAt = now;
    }

    /**
     * Only used when auth.otp.extend-ttl-on-resend is enabled. Off by default, because
     * extending on every resend lets one code live indefinitely.
     */
    public void extendExpiry(Instant newExpiry) {
        if (newExpiry.isAfter(this.expiresAt)) {
            this.expiresAt = newExpiry;
        }
    }

    public void consume(Instant now) {
        this.status = OtpStatus.CONSUMED;
        this.consumedAt = now;
    }

    public void supersede() {
        this.status = OtpStatus.SUPERSEDED;
    }

    public void expire() {
        this.status = OtpStatus.EXPIRED;
    }

    public UUID getId() {
        return id;
    }

    public UUID getSessionId() {
        return sessionId;
    }

    public String getCode() {
        return code;
    }

    public OtpStatus getStatus() {
        return status;
    }

    public int getSendCount() {
        return sendCount;
    }

    public Instant getIssuedAt() {
        return issuedAt;
    }

    public Instant getExpiresAt() {
        return expiresAt;
    }

    public Instant getLastSentAt() {
        return lastSentAt;
    }

    public Instant getConsumedAt() {
        return consumedAt;
    }
}
