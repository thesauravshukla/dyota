# order-management-service

Owns **identity** and **logged-in sessions**. This is the only service the Flutter client
talks to. Verification lives entirely in `authentication-service`, which holds no user
records at all — the only thing that crosses the boundary is a verified identifier.

```
Flutter → order-management-service ──┬─ POST /auth/login/start   → authentication-service /otp/send
                      ├─ POST /auth/login/resend  → authentication-service /otp/resend
                      └─ POST /auth/login/verify  → authentication-service /verify
                                ↓ verified identifier
                         find-or-create user, open session, return bearer token
```

Login is **passwordless**: phone or email plus an OTP is the entire credential. There is
no password column, no reset flow, and no SMTP dependency here.

Login is also **signup**: a verified identifier with no account behind it becomes one, and
the response carries `isNewUser` so the client can route to onboarding.

## Running locally

Both services and both databases:

```bash
cd authentication-service && docker compose up -d && ./gradlew bootRun   # :8081
cd order-management-service              && docker compose up -d && ./gradlew bootRun   # :8080
```

```bash
# start a login
curl -s -XPOST localhost:8080/api/v1/auth/login/start \
  -H 'Content-Type: application/json' \
  -d '{"identifier":"+919812345678","identifierType":"PHONE"}'

# read the code from the authentication-service log, then
curl -s -XPOST localhost:8080/api/v1/auth/login/verify \
  -H 'Content-Type: application/json' \
  -d '{"sessionId":"<id>","code":"<code>"}'

# use the token
curl -s localhost:8080/api/v1/auth/me -H 'Authorization: Bearer <token>'
```

## API

| Method | Path | Auth | Purpose |
|---|---|---|---|
| `POST` | `/api/v1/auth/login/start` | public | Begin login; sends an OTP |
| `POST` | `/api/v1/auth/login/resend` | public | Resend the same OTP |
| `POST` | `/api/v1/auth/login/verify` | public | Submit the code; returns a token |
| `GET` | `/api/v1/auth/me` | bearer | Current user |
| `GET` | `/api/v1/auth/sessions` | bearer | Active devices, current one flagged |
| `POST` | `/api/v1/auth/logout` | bearer | End this session |
| `POST` | `/api/v1/auth/logout/all` | bearer | End every session |
| `GET` | `/actuator/health` | public | Liveness / readiness |

A wrong code returns **200** with `authenticated: false` and a `reason`, so the client
branches on the body rather than on transport errors. Cooldown and cap breaches from
authentication-service pass straight through as **429** with `Retry-After`.

## Tokens

Opaque, not JWT. A token is 256 bits of `SecureRandom`, base64url encoded, and carries no
information whatsoever — the server learns who you are by looking the digest up.

**Only the SHA-256 digest is stored.** The raw token exists solely on the client; storing
it would put live credentials for every logged-in user in one table. Plain SHA-256 rather
than BCrypt is deliberate: the input is 256 bits of CSPRNG output, not a guessable human
secret, so there is nothing for a slow hash to defend against — and this runs on every
authenticated request.

**Tokens do not expire.** A session ends when the user logs out, when the per-user cap
pushes it out, or when an operator revokes it. That is a deliberate choice with a real
consequence: a leaked token stays valid until someone ends it, which is why
`/auth/sessions` and `/auth/logout/all` exist. `login.session.ttl` switches on absolute
expiry without a migration, because the `expires_at` column is already there.

The trade against JWT: revocation is immediate here, which JWT cannot do. The cost is that
a second service cannot validate a token by itself — it either calls this API or sits
behind a gateway that validates once and forwards the user id.

## Configuration

| Key | Default | Meaning |
|---|---|---|
| `login.session.ttl` | *(unset)* | Absolute token expiry; unset means never |
| `login.session.revoked-retention` | `P30D` | How long logged-out rows are kept before sweeping |
| `login.session.max-per-user` | `10` | Oldest live sessions beyond this are revoked on login |
| `login.session.last-used-precision` | `PT5M` | How stale `last_used_at` may get before a rewrite |
| `login.auth-service.base-url` | `http://localhost:8081` | Where authentication-service lives |
| `login.auth-service.api-key` | *(blank)* | Must match its `SERVICE_API_KEY` |
| `login.cors.allowed-origins` | localhost | This API is public, unlike authentication-service |

## Design notes

**The caller's IP is forwarded** to authentication-service as `X-Forwarded-For`. Without
it, that service's per-IP send cap would see one address for every user on earth and
throttle everyone globally after twenty requests.

**The HTTP call happens outside any transaction.** `LoginService` is deliberately not
transactional; the database work is delegated to `LoginCompleter` afterwards, so a
connection is never held open across a network round trip.

**First-login races are settled by the database.** Two simultaneous first logins for the
same identifier hit a unique constraint; the loser reads back the winner's row rather than
creating a duplicate account.

**`last_used_at` is throttled** so a read does not become a write on every request.

## Known gaps

- No profile editing endpoint yet; `display_name` is only ever null.
- Account recovery is control of the identifier. Someone who loses their number loses the
  account, and a recycled number grants access to whoever receives it — worth a support
  path or a second contact point before launch.
- No edge rate limiting on `/login/start` itself; today the caps live in
  authentication-service, which is one hop too late to protect this service's own traffic.

## Tests

```bash
./gradlew test
```

22 tests: unit tests for token generation and identifier rules, plus integration tests
against a real Postgres via Testcontainers (Docker required) that drive the full flow over
HTTP with authentication-service faked out.
