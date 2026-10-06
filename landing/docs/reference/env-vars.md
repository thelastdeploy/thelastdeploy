---
title: "Environment Variables Reference"
description: "Reference guide for all environment variables across TLD CLI, Backend, Frontend, and Docker Compose."
section: "Reference"
---

## CLI Environment Variables

These variables alter `tld` CLI runtime execution without modifying `~/.tld/config.json`.

| Variable | Default | Purpose |
| :--- | :--- | :--- |
| `TLD_API_URL` | `http://localhost:9001` | Overrides backend API endpoint URI. |
| `TLD_CONFIG_DIR` | `~/.tld` | Custom location for configuration file storage. |
| `TLD_TOKEN` | *None* | Overrides stored JWT access token for non-interactive CI automation. |
| `NO_COLOR` | *None* | Disables ANSI color codes in terminal output when set to any value. |

---

## Backend API Environment Variables (`web/backend`)

Used by FastAPI services in `infra/local/docker-compose.yml`.

| Variable | Default | Purpose |
| :--- | :--- | :--- |
| `DATABASE_URL` | `postgresql+asyncpg://...` | AsyncPG PostgreSQL database connection URI. |
| `SECRET_KEY` | `tld-local-secret-key...` | Secret key used for signing and verifying JWT tokens. |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `10080` (7 days) | Validity period of issued user JWT tokens. |
| `ENVIRONMENT` | `development` | Runtime mode (`development` or `production`). |
| `ALLOWED_ORIGINS` | `http://localhost:9000,...` | Comma-separated CORS allowed origin list. |

---

## Web Frontend Environment Variables (`web/frontend`)

Used by Next.js user dashboard application.

| Variable | Default | Purpose |
| :--- | :--- | :--- |
| `NEXT_PUBLIC_API_URL` | `http://localhost:9001` | Public backend API URL accessible from browser client components. |
| `PORT` | `9000` | HTTP port for Next.js web application server. |

---

## Landing Site Environment Variables (`landing`)

Used by documentation server and marketing site.

| Variable | Default | Purpose |
| :--- | :--- | :--- |
| `PORT` | `9002` | Next.js HTTP server port for documentation web app. |