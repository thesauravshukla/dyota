CREATE TABLE users (
  id                UUID         NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  email             VARCHAR(255) NOT NULL UNIQUE,
  password_hash     VARCHAR(255) NULL,
  name              VARCHAR(120) NULL,
  email_verified_at TIMESTAMPTZ  NULL,
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE refresh_tokens (
  id         UUID         NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash VARCHAR(255) NOT NULL,
  expires_at TIMESTAMPTZ  NOT NULL,
  revoked_at TIMESTAMPTZ  NULL,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX ix_refresh_tokens_user ON refresh_tokens(user_id);

CREATE TABLE email_verification_tokens (
  id          UUID         NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMPTZ  NOT NULL,
  consumed_at TIMESTAMPTZ  NULL,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX ix_email_verification_tokens_user ON email_verification_tokens(user_id);

CREATE TABLE password_reset_tokens (
  id          UUID         NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMPTZ  NOT NULL,
  consumed_at TIMESTAMPTZ  NULL,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX ix_password_reset_tokens_user ON password_reset_tokens(user_id);

CREATE TABLE oauth_accounts (
  id         UUID         NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider   VARCHAR(32)  NOT NULL,
  subject    VARCHAR(255) NOT NULL,
  email      VARCHAR(255) NULL,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_oauth_provider_subject UNIQUE (provider, subject)
);
CREATE INDEX ix_oauth_accounts_user ON oauth_accounts(user_id);
