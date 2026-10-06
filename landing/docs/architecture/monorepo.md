---
title: "Monorepo Structure & Build Tools"
description: "Repository organization, Makefile targets, and Docker Compose development environment."
section: "Architecture"
---

The Last Deploy is structured as a monorepo containing all platform services, CLI tools, curriculum definitions, and development infrastructure.

## Directory Organization

```text
DevLab/
├── agent/                             # Go CLI source code (main.go, cmd/, internal/)
├── challenges/                        # Authoritative curriculum specs & validators
├── infra/local/                       # Docker Compose & container Dockerfiles
├── landing/                           # Landing page & docs app (docs.thelastdeploy.com)
│   ├── docs/                          # Markdown documentation content (.md)
│   └── navigation.yaml                # Declarative documentation navigation config
├── web/                               # Platform web services
│   ├── backend/                       # Python FastAPI REST API & Async SQLAlchemy models
│   └── frontend/                      # Next.js 16 learning dashboard (Port 9000)
└── Makefile                           # Project build and orchestration targets
```

## Makefile Targets

The root `Makefile` orchestrates building binaries, running test suites, and launching local development environments.

| Target | Command | Purpose |
| :--- | :--- | :--- |
| `make build` | `go build -o bin/tld ./agent` | Compiles the Go CLI binary for host architecture into `bin/tld`. |
| `make install` | `cp bin/tld /usr/local/bin/tld` | Copies compiled binary to system path. |
| `make dev-up` | `docker compose -f infra/local/docker-compose.yml up --build -d` | Launches local database, backend, frontend, and landing containers. |
| `make dev-down` | `docker compose -f infra/local/docker-compose.yml down` | Stops and removes local development containers. |
| `make dev-seed` | `docker compose -f infra/local/docker-compose.yml run --rm db-seeder` | Re-executes the backend challenge seeder to populate PostgreSQL from `challenges/`. |
| `make verify` | `go fmt + go vet + go test` | Runs Go formatting checks, static analysis (`go vet`), and unit test suites. |
| `make dist` | Cross-compilation scripts | Builds static release binaries for Linux (`amd64`/`arm64`) and macOS (`amd64`/`arm64`) in `dist/`. |

## Local Stack Services (`infra/local/docker-compose.yml`)

Running `make dev-up` boots five microservices connected over bridge network `tld-net`:

1. **`db` (Port 5432):** PostgreSQL 16 Alpine container storing user profiles, XP, streaks, and module models.
2. **`db-seeder`:** One-shot script executing `web/backend/seed/seed_modules.py` to populate database tables from `/challenges`.
3. **`backend` (Port 9001):** FastAPI server exposing API routes for user auth, module metadata, and challenge completions.
4. **`frontend` (Port 9000):** Next.js user dashboard app for browsing tracks and attempting lessons.
5. **`landing` (Port 9002):** Next.js application serving `docs.thelastdeploy.com`.