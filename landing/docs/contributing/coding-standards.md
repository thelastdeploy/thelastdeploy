---
title: "Coding Standards"
description: "Language standards for Go, Python, TypeScript, and Shell scripts across the monorepo."
section: "Contributing"
---

## Standards by Language

### 1. Go (`agent/`)
* Format code with `gofmt`.
* Run static analysis using `go vet ./...`.
* Keep CLI command definitions isolated inside `agent/cmd/`.

### 2. Python (`web/backend/`)
* Use type annotations for function signatures.
* Follow PEP 8 formatting conventions (`black` / `ruff`).

### 3. TypeScript / React (`web/frontend/` & `landing/`)
* Define explicit types in `types.ts`.
* Use React Server Components by default; use `"use client"` only when interactive browser state is required.

### 4. Shell Scripts (`validator.sh`)
* Include `set -euo pipefail` at the top of bash scripts.
* Format assertion progress as `CHECK_ID|STATUS|MESSAGE`.