-- login-api schema.
--
-- This service owns identity and logged-in sessions. Verification lives entirely in
-- authentication-service, which holds no user records at all; the only thing that
-- crosses the boundary is a verified identifier.

CREATE TABLE app_user (
    id              UUID         PRIMARY KEY,
    phone           VARCHAR(20)  UNIQUE,
    email           VARCHAR(320) UNIQUE,
    display_name    VARCHAR(120),
    status          VARCHAR(16)  NOT NULL,
    phone_verified  BOOLEAN      NOT NULL DEFAULT FALSE,
    email_verified  BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ  NOT NULL,
    updated_at      TIMESTAMPTZ  NOT NULL,
    last_login_at   TIMESTAMPTZ,

    CONSTRAINT chk_user_status CHECK (status IN ('ACTIVE', 'SUSPENDED', 'DELETED')),
    -- Login is passwordless, so an account is worthless without a contact point to
    -- prove control of. At least one must always be present.
    CONSTRAINT chk_user_has_identifier CHECK (phone IS NOT NULL OR email IS NOT NULL)
);


CREATE TABLE user_session (
    id            UUID         PRIMARY KEY,
    -- SHA-256 of the bearer token. The raw token exists only on the client: storing it
    -- would put live credentials for every logged-in user in this table.
    token_hash    VARCHAR(64)  NOT NULL UNIQUE,
    user_id       UUID         NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    device_label  VARCHAR(200),
    created_at    TIMESTAMPTZ  NOT NULL,
    last_used_at  TIMESTAMPTZ  NOT NULL,
    -- Null means "never expires", which is the configured behaviour. The column exists
    -- so switching on absolute expiry later is configuration rather than a migration.
    expires_at    TIMESTAMPTZ,
    revoked_at    TIMESTAMPTZ
);

-- The hot path: every authenticated request is one lookup on this index.
CREATE UNIQUE INDEX idx_session_token ON user_session (token_hash);
-- Drives "log out everywhere" and the per-user session cap.
CREATE INDEX idx_session_user ON user_session (user_id) WHERE revoked_at IS NULL;
-- Drives the sweep of logged-out sessions.
CREATE INDEX idx_session_revoked ON user_session (revoked_at) WHERE revoked_at IS NOT NULL;
