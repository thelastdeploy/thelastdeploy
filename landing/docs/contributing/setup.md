---
title: "Development Setup & Monorepo Environment"
description: "Setting up your local environment for contributing to TLD."
section: "Contributing"
---

## Prerequisites

To build and run the TLD monorepo locally, you need:
* **Go 1.22+**
* **Node.js 20+ & npm**
* **Python 3.12+**
* **Docker Engine & Docker Compose**
* **Make**

## Local Microservice Stack

Boot the complete local development environment:

```bash
git clone https://github.com/thelastdeploy/thelastdeploy.git
cd thelastdeploy

make dev-up
```

This starts 5 containers via Docker Compose:
* **Backend API (`tld-backend`):** `http://localhost:9001`
* **Frontend UI (`tld-frontend`):** `http://localhost:9000`
* **Landing Page & Docs (`tld-landing`):** `http://localhost:9002`
* **PostgreSQL Database (`tld-db`):** `localhost:5432`
* **Database Seeder (`tld-db-seeder`):** One-shot seeder container.

## Compiling the CLI Agent

Build the Go CLI binary locally:

```bash
make build
./bin/tld version
```