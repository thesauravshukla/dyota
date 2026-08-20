package com.dyota.oms.user.domain;

import com.dyota.oms.support.IdentifierType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;

/**
 * The permanent identity record — the table authentication-service deliberately does
 * not have. Created on first successful verification, since login and signup are the
 * same flow in a passwordless design.
 */
@Entity
@Table(name = "app_user")
public class AppUser {

    @Id
    private UUID id;

    @Column(length = 20, unique = true)
    private String phone;

    @Column(length = 320, unique = true)
    private String email;

    @Column(name = "display_name", length = 120)
    private String displayName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private UserStatus status;

    @Column(name = "phone_verified", nullable = false)
    private boolean phoneVerified;

    @Column(name = "email_verified", nullable = false)
    private boolean emailVerified;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "last_login_at")
    private Instant lastLoginAt;

    protected AppUser() {
        // for JPA
    }

    /** Creates the account implied by a verified identifier. */
    public static AppUser createVerified(String identifier, IdentifierType type, Instant now) {
        AppUser u = new AppUser();
        u.id = UUID.randomUUID();
        u.status = UserStatus.ACTIVE;
        u.createdAt = now;
        u.updatedAt = now;
        if (type == IdentifierType.PHONE) {
            u.phone = identifier;
            u.phoneVerified = true;
        } else {
            u.email = identifier;
            u.emailVerified = true;
        }
        return u;
    }

    /**
     * A returning user has just proved control of this identifier again, so the matching
     * verified flag is refreshed along with the login timestamp.
     */
    public void recordLogin(IdentifierType type, Instant now) {
        if (type == IdentifierType.PHONE) {
            this.phoneVerified = true;
        } else {
            this.emailVerified = true;
        }
        this.lastLoginAt = now;
        this.updatedAt = now;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public UUID getId() {
        return id;
    }

    public String getPhone() {
        return phone;
    }

    public String getEmail() {
        return email;
    }

    public String getDisplayName() {
        return displayName;
    }

    public UserStatus getStatus() {
        return status;
    }

    public boolean isPhoneVerified() {
        return phoneVerified;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getLastLoginAt() {
        return lastLoginAt;
    }
}
