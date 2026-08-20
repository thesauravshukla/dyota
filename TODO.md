# Dyota — TODO

Status: `authentication-service` and `order-management-service` built, containerised, 48 tests green. Nothing committed yet.

## Blockers before real users

- [ ] Rotate the Resend API key — it was pasted into a chat transcript

- [ ] Wire an SMS provider (Twilio / MSG91) — `SmsOtpSender` currently throws
- [ ] Start India DLT registration (entity + header + templates) — calendar time, start early
- [ ] Set `SERVICE_API_KEY` — auth-service accepts any caller while blank
- [ ] Replace plain SHA-256 in `rate_counter` with HMAC + server secret — phone hashes are brute-forceable today
- [ ] Create least-privilege DB roles — `authsvc` and `loginsvc` are both superusers
- [ ] Move DB passwords out of `docker-compose.yml` into a secret store

## Email (unblocks login without SMS)

- [x] Add Mailpit to auth compose for local SMTP
- [x] Switch `OTP_SENDER=real` + Resend SMTP — dyota.shop verified, sending live
- [x] Return a clean `CHANNEL_UNAVAILABLE` when phone login is attempted email-only
- [ ] Add a test-number bypass (fixed code) for dev and app-store review

## authentication-service

- [ ] Decide on the PII-free audit table — no abuse trail exists today by design
- [ ] Encrypt the `otp_issue.code` column (currently plaintext by decision)
- [ ] Move OTP dispatch to an outbox + async worker if provider latency hurts `/otp/send`

## order-management-service

- [ ] Build the orders domain — the reason the DB was renamed
- [ ] Add edge rate limiting on `/login/start` (caps currently live one hop downstream)
- [ ] Add a profile endpoint — `display_name` is always null
- [ ] Decide an account recovery path for lost / recycled numbers
- [ ] Rename DB user `loginsvc` → `omssvc` (stale after the service rename)

## Flutter app

- [ ] Login screen against `/auth/login/start` + `/verify`
- [ ] Secure token storage (`flutter_secure_storage`, not SharedPreferences)
- [ ] Auth interceptor + route guard
- [ ] Route on `isNewUser` to onboarding vs home

## Deploy / ops

- [ ] Pick hosting — Cloud Run / Render / single VPS
- [ ] Managed Postgres, or self-hosted with automated `pg_dump` off-box
- [ ] Test a restore from backup before launch
- [ ] Keep `auth-service` on internal ingress only
- [ ] TLS + domain, point `CORS_ALLOWED_ORIGINS` at the real origin
- [ ] CI/CD: build → `./gradlew test` → push image → deploy
- [ ] Log aggregation + alerting on health endpoints
- [ ] Deploy one replica first — a bad Flyway migration takes the service down

## Housekeeping

- [ ] Commit both services (nothing is in git yet)
- [ ] Remove orphaned volume `login-api_dyota-login-pgdata`
- [ ] Write `DEPLOYMENT.md`
