package com.dyota.oms.session.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;

/**
 * A logged-in session. The bearer token itself is never stored — only its SHA-256
 * digest — so this table cannot be used to impersonate anyone.
 *
 * <p>Sessions do not expire on their own by configuration; one ends when the user logs
 * out, when they are pushed out by the per-user session cap, or when an operator
 * revokes it.
 */
@Entity
@Table(name = "user_session")
public class UserSession {

    @Id
    private UUID id;

    @Column(name = "token_hash", nullable = false, length = 64, unique = true)
    private String tokenHash;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "device_label", length = 200)
    private String deviceLabel;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "last_used_at", nullable = false)
    private Instant lastUsedAt;

    @Column(name = "expires_at")
    private Instant expiresAt;

    @Column(name = "revoked_at")
    private Instant revokedAt;

    protected UserSession() {
        // for JPA
    }

    public static UserSession open(
            UUID userId, String tokenHash, String deviceLabel, Instant now, Instant expiresAt) {
        UserSession s = new UserSession();
        s.id = UUID.randomUUID();
        s.userId = userId;
        s.tokenHash = tokenHash;
        s.deviceLabel = deviceLabel;
        s.createdAt = now;
        s.lastUsedAt = now;
        s.expiresAt = expiresAt;
        return s;
    }

    public boolean isActiveAt(Instant now) {
        if (revokedAt != null) {
            return false;
        }
        return expiresAt == null || now.isBefore(expiresAt);
    }

    public void revoke(Instant now) {
        if (this.revokedAt == null) {
            this.revokedAt = now;
        }
    }

    public void touch(Instant now) {
        this.lastUsedAt = now;
    }

    public UUID getId() {
        return id;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getDeviceLabel() {
        return deviceLabel;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getLastUsedAt() {
        return lastUsedAt;
    }

    public Instant getExpiresAt() {
        return expiresAt;
    }

    public Instant getRevokedAt() {
        return revokedAt;
    }
}
