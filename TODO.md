# Dyota — TODO

Status: both services containerised and committed. Flutter app runs on Android with the full email login flow working end to end. Email-only until the business entity exists.

## Blockers before real users

- [ ] Rotate the Resend API key — it was pasted into a chat transcript
- [ ] Point auth-service back at Resend — `.env` is on Mailpit after testing
- [ ] Write the real positioning line — the banner ships a `[ … ]` placeholder
- [ ] Reconsider the weave mark: the interlace disappears at app-bar size

- [ ] Set `SERVICE_API_KEY` — auth-service accepts any caller while blank
- [ ] Replace plain SHA-256 in `rate_counter` with HMAC + server secret — phone hashes are brute-forceable today
- [ ] Create least-privilege DB roles — `authsvc` and `loginsvc` are both superusers
- [ ] Move DB passwords out of `docker-compose.yml` into a secret store

## Email — the launch channel

- [x] Add Mailpit to auth compose for local SMTP
- [x] Switch `OTP_SENDER=real` + Resend SMTP — dyota.shop verified, sending live
- [x] Return a clean `CHANNEL_UNAVAILABLE` when phone login is attempted email-only
- [ ] Add a test-address bypass (fixed code) for dev and app-store review

## Deferred — needs a registered business entity

- [ ] India DLT: entity, header, then template registration (blocked on incorporation)
- [ ] Wire an SMS provider (Twilio / MSG91) once DLT clears
- [ ] Flip `SMS_ENABLED=true` — the phone channel already refuses cleanly until then

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

- [x] Install the Flutter SDK
- [x] Android toolchain: Studio, cmdline-tools, licences, emulator
- [ ] Install Xcode for iOS builds (needs your Apple ID)

- [x] Login screen against `/auth/login/start` + `/verify`
- [x] Secure token storage via the platform keystore
- [x] Auth gate: splash / login / home, survives restart
- [x] Welcome banner shows once on `isNewUser`

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

- [x] Commit both services
- [ ] Remove orphaned volume `login-api_dyota-login-pgdata`
- [ ] Write `DEPLOYMENT.md`
