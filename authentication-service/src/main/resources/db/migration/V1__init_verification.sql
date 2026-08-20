-- authentication-service schema.
--
-- This service owns the verification domain and nothing else. There is deliberately
-- no users table: identity lives in the login API. Everything here is session-scoped
-- and is destroyed when the session reaches a terminal state.

CREATE TABLE verification_session (
    id                  UUID         PRIMARY KEY,
    identifier          VARCHAR(320) NOT NULL,
    identifier_type     VARCHAR(16)  NOT NULL,
    purpose             VARCHAR(32)  NOT NULL,
    status              VARCHAR(16)  NOT NULL,
    user_id             UUID         NULL,
    send_count          INT          NOT NULL DEFAULT 0,
    verify_attempts     INT          NOT NULL DEFAULT 0,
    last_sent_at        TIMESTAMPTZ  NULL,
    login_time          TIMESTAMPTZ  NULL,
    created_at          TIMESTAMPTZ  NOT NULL,
    expires_at          TIMESTAMPTZ  NOT NULL,
    terminated_at       TIMESTAMPTZ  NULL,
    termination_reason  VARCHAR(32)  NULL,
    client_ip           VARCHAR(45)  NULL,
    version             BIGINT       NOT NULL DEFAULT 0,

    CONSTRAINT chk_session_identifier_type CHECK (identifier_type IN ('EMAIL', 'PHONE')),
    CONSTRAINT chk_session_status          CHECK (status IN ('PENDING', 'VERIFIED', 'LOCKED', 'EXPIRED')),
    CONSTRAINT chk_session_counts          CHECK (send_count >= 0 AND verify_attempts >= 0)
);

-- Drives the cleanup sweep.
CREATE INDEX idx_session_expires ON verification_session (expires_at);
-- Drives "does this identifier already have a live session?" lookups.
CREATE INDEX idx_session_lookup ON verification_session (identifier, status) WHERE status = 'PENDING';
-- Drives the post-terminal retention sweep.
CREATE INDEX idx_session_terminated ON verification_session (terminated_at) WHERE terminated_at IS NOT NULL;


CREATE TABLE otp_issue (
    id            UUID         PRIMARY KEY,
    session_id    UUID         NOT NULL REFERENCES verification_session (id) ON DELETE CASCADE,
    code          VARCHAR(10)  NOT NULL,
    status        VARCHAR(16)  NOT NULL,
    send_count    INT          NOT NULL DEFAULT 1,
    issued_at     TIMESTAMPTZ  NOT NULL,
    expires_at    TIMESTAMPTZ  NOT NULL,
    last_sent_at  TIMESTAMPTZ  NOT NULL,
    consumed_at   TIMESTAMPTZ  NULL,

    CONSTRAINT chk_otp_status CHECK (status IN ('ACTIVE', 'CONSUMED', 'EXPIRED', 'SUPERSEDED'))
);

CREATE INDEX idx_otp_session ON otp_issue (session_id);

-- The resend contract, enforced by the database rather than by application discipline:
-- a session can never hold two live codes, so resend has exactly one row it can re-dispatch.
CREATE UNIQUE INDEX idx_otp_one_active ON otp_issue (session_id) WHERE status = 'ACTIVE';


-- Rate limiting has to outlive the sessions it counts. If we counted rows in
-- verification_session instead, cleanup would silently reset every attacker's budget,
-- so the per-identifier and per-IP caps are kept in their own fixed-window counters.
-- scope_key is a SHA-256 hex digest, so no raw identifier or IP is stored here.
CREATE TABLE rate_counter (
    scope        VARCHAR(16)  NOT NULL,
    scope_key    CHAR(64)     NOT NULL,
    window_start TIMESTAMPTZ  NOT NULL,
    count        INT          NOT NULL DEFAULT 0,
    expires_at   TIMESTAMPTZ  NOT NULL,

    PRIMARY KEY (scope, scope_key, window_start),
    CONSTRAINT chk_rate_scope CHECK (scope IN ('IDENTIFIER', 'IP'))
);

CREATE INDEX idx_rate_counter_expires ON rate_counter (expires_at);
