# Dyota API

Spring Boot 3 + Java 21 service for Dyota authentication. See `../docs/auth-hld.md` and `../docs/auth-lld.md` for design.

## Prerequisites

- **JDK 21** (LLD target). JDK 17 may also build with minor tweaks.
- **Gradle** (only needed once to generate the wrapper). Install via SDKMAN or `sudo apt install gradle`.
- **PostgreSQL** (local or Docker).
- **MailHog** (or any SMTP) for verification / reset email in dev.

## First-time setup

```bash
cd backend
gradle wrapper                # creates ./gradlew
cp .env.example .env          # then fill values; or export them
docker compose up -d          # starts PostgreSQL on localhost:5432
./gradlew bootRun
```

## Configuration

All environment-specific settings live in `application.yml` and read from env vars. See `.env.example`.

## Database

Schema is owned by Flyway under `src/main/resources/db/migration/`. The first migration (`V1__init_auth.sql`) creates the auth tables defined in the LLD.

Start PostgreSQL for local dev:

```bash
docker compose up -d
```

Connection defaults (see `.env.example`):

| Variable | Default |
|----------|---------|
| `DB_HOST` | `localhost` |
| `DB_PORT` | `5432` |
| `DB_NAME` | `dyota` |
| `DB_USER` | `dyota` |
| `DB_PASSWORD` | `changeme` |

Flyway creates tables on first `bootRun`. No manual `CREATE DATABASE` is needed when using the Docker Compose service above.

## Endpoints (auth)

See `../docs/auth-lld.md` §3.3 for the complete contract. Base path: `/api/v1`.
