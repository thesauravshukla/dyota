# authentication-service

Owns the **verification domain** and nothing else. It proves that whoever holds a session
controls a phone number or email address, and answers one question: may this session
proceed to login?

It is deliberately **not** an identity service. There is no users table here. Identity —
find-or-create the account, issue access and refresh tokens — belongs to the login API,
which is this service's only caller.

```
client → login API ──┬─ POST /api/v1/otp/send    → sessionId
                     ├─ POST /api/v1/otp/resend  → same code re-sent
                     └─ POST /api/v1/verify      → { verified, canLogin }
                            ↓
                     login API issues JWTs
```

## Why user data is session-scoped

Every row here is destroyed when its session terminates, so the service never accumulates
a record of everyone who has ever logged in. Cleanup is structural rather than a job that
can be forgotten:

- `otp_issue` cascades from `verification_session` via `ON DELETE CASCADE`
- terminal transitions delete inline (or after a short retention window)
- a scheduled sweep collects abandoned sessions as a backstop

The one thing that intentionally outlives a session is the rate counter — see below.

## Running locally

```bash
docker compose up -d          # Postgres on :5433, its own database and volume
./gradlew bootRun             # service on :8081
```

The dev profile uses `LoggingOtpSender`, which prints the code to the log, so the whole
flow works with no SMTP or SMS provider configured.

```bash
# 1. start a verification
curl -s -XPOST localhost:8081/api/v1/otp/send \
  -H 'Content-Type: application/json' \
  -d '{"identifier":"+919876543210","identifierType":"PHONE","purpose":"LOGIN"}'

# 2. read the code from the service log, then
curl -s -XPOST localhost:8081/api/v1/verify \
  -H 'Content-Type: application/json' \
  -d '{"sessionId":"<id>","code":"<code>"}'
```

## API

| Method | Path | Purpose |
|---|---|---|
| `POST` | `/api/v1/otp/send` | Start a session and dispatch a code |
| `POST` | `/api/v1/otp/resend` | Re-dispatch **the same** code, subject to cooldown |
| `POST` | `/api/v1/verify` | Submit a code; returns `verified` / `canLogin` |
| `GET` | `/api/v1/sessions/{id}` | Status and counters, never the code |
| `POST` | `/api/v1/sessions/{id}/terminate` | Delete the session and its codes now |
| `GET` | `/actuator/health` | Liveness / readiness |

A failed verification returns **200** with `verified: false` and a `reason`
(`INVALID_CODE`, `CODE_EXPIRED`, `ATTEMPTS_EXHAUSTED`, `SESSION_EXPIRED`,
`ALREADY_VERIFIED`). Only transport-level problems are 4xx/5xx, so the login API branches
on the body rather than on status codes. Cooldown and cap breaches return **429** with a
`Retry-After` header.

## Configuration

Every limit is service-level config, changeable per environment without a code change.

| Key | Default | Meaning |
|---|---|---|
| `auth.otp.length` | `6` | Digits per code |
| `auth.otp.ttl` | `PT5M` | Code lifetime |
| `auth.otp.resend-cooldown` | `PT30S` | Minimum gap between dispatches |
| `auth.otp.max-sends-per-session` | `3` | Initial send plus resends |
| `auth.otp.max-verify-attempts` | `5` | Wrong codes before the session locks |
| `auth.otp.extend-ttl-on-resend` | `false` | Whether resend pushes out the expiry |
| `auth.session.ttl` | `PT15M` | How long a session may stay open |
| `auth.session.post-terminal-retention` | `PT60S` | Grace window before deletion; `PT0S` deletes at once |
| `auth.rate-limit.per-identifier-sends` | `5` | Sends per identifier per window |
| `auth.rate-limit.per-ip-sends` | `20` | Sends per IP per window |
| `auth.service-api-key` | *(blank)* | Required `X-Service-Key`; blank disables the check |

## Design notes worth knowing

**Resend returns the same code.** A partial unique index (`WHERE status = 'ACTIVE'`) allows
at most one live code per session, so resend has exactly one row it can re-dispatch. Two
deliberate exceptions:

- resend does **not** extend the code's expiry, so one code cannot be kept alive forever
- if the code has already expired it cannot be safely revived, so a fresh one is issued and
  the response says `newCodeIssued: true`

**Cooldown and counters are race-safe.** Resend and verify take `SELECT … FOR UPDATE` on the
session row, so the check and the increment are one atomic unit. Without it two simultaneous
taps both observe the pre-increment state and both pass.

**Rate counters outlive sessions on purpose.** Counting rows in `verification_session` would
have been simpler, but cleanup deletes them within minutes — which would hand every caller a
fresh budget as soon as their sessions were swept. The per-identifier and per-IP caps live in
their own fixed-window table, keyed by a SHA-256 digest so no raw identifier or IP is stored.
These caps are load-bearing: the per-session cap alone is bypassed by opening a new session
per send.

**Codes are stored in plaintext.** A deliberate decision, mitigated by the short TTL, the
cascade delete, and never logging the code outside the dev sender. If you want that changed,
encrypting the column touches `OtpService` and one migration.

**Delivery happens after commit**, so a rolled-back transaction can never leave a real message
in someone's inbox. The inverse — committed session, failed delivery — is recoverable through
resend.

**Cleanup uses a transaction-scoped advisory lock** (`pg_try_advisory_xact_lock`), so exactly
one replica sweeps and the lock releases automatically even if that pod dies mid-sweep.

## Known gaps

- No SMS provider is wired; `SmsOtpSender` fails loudly rather than pretending to deliver.
- No audit trail. Cleanup destroys the evidence by design, so abuse cannot be investigated
  retrospectively. A PII-free audit table would fix this without reintroducing user rows.
- Delivery is synchronous, so provider latency lands on `/otp/send`. An outbox and async
  worker is the answer if that becomes a problem.

## Tests

```bash
./gradlew test
```

Integration tests run against a real Postgres via Testcontainers (Docker required), because
the invariants worth testing — the partial unique index, the cascade, `SELECT FOR UPDATE` —
only exist in the database.
