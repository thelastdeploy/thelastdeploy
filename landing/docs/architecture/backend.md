---
title: "Backend Architecture & REST API"
description: "FastAPI backend architecture, database ORM models, auth handlers, and challenge seeding."
section: "Architecture"
---

The TLD Backend (`web/backend/`) is an asynchronous REST API built with FastAPI, Async SQLAlchemy, AsyncPG, and PostgreSQL 16. It handles authentication, tracks user XP and streaks, records challenge completions, and seeds database models from `/challenges`.

## Technology Stack

* **API Framework:** FastAPI (Uvicorn ASGI runner)
* **ORM & Database:** SQLAlchemy 2.0 (Async) + `asyncpg` driver + PostgreSQL 16 Alpine
* **Data Schemas:** Pydantic v2
* **Password Hashing:** Passlib with bcrypt
* **Token Management:** PyJWT (HS256)

## API Router Organization (`web/backend/app/routers/`)

* `auth.py`: User registration, login, JWT token issuance, email verification, password reset, and CLI Device Authorization flow (`/api/v1/auth/cli/device-code` and `/token`).
* `modules.py`: Queries for tracks, modules, sections, and lab metadata.
* `results.py`: Lab completion verification (`POST /api/v1/results/check`) and XP crediting.
* `users.py`: User profile stats, streak day calculations, and XP leaderboards.
* `builder.py`: Authoring endpoints for maintainers creating new challenge modules.

## CLI Device Authorization Sequence

To authenticate a command-line terminal without typing passwords into shell prompts, `tld login` implements the OAuth2 Device Authorization Grant (RFC 8628):

```
1. CLI Agent ────────> POST /api/v1/auth/cli/device-code ────────> Backend API
                       <────── device_code, user_code ────────────

2. User Browser ──────> GET http://localhost:9000/cli/auth ──────> Confirms user_code

3. CLI Agent ────────> Polls POST /api/v1/auth/cli/token ────────> Receives JWT & device_key
```

## Curriculum Database Seeder (`web/backend/seed/seed_modules.py`)

When the local stack starts, the `db-seeder` container runs `seed_modules.py`:

1. Traverses `/app/challenges` subdirectories.
2. Reads `module.yaml` for module metadata and section ordering.
3. Reads `section.yaml` and `lab.yaml` files.
4. Computes precalculated totals (`total_sections`, `total_xp`) and writes records to `modules`, `sections`, and `labs` PostgreSQL tables.