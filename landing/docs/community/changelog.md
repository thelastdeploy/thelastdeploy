---
title: "Changelog & Release Notes"
description: "History of changes across TLD CLI, API services, and documentation."
section: "Community"
---

## Release History

### v1.1.0 — Docs Architecture & System Diagnostics

#### CLI (`tld`)
* Added `tld doctor` command to check Docker socket accessibility, user group permissions, and disk space.
* Refactored device auth polling loop in `tld login` to handle authorization timeouts cleanly.
* Updated `tld check` to output detailed execution logs when validation scripts fail with exit code `1`.

#### Documentation
* Migrated documentation architecture to decoupled Markdown files stored in `landing/docs/`.
* Added file-based slug routing and YAML navigation configuration in `landing/navigation.yaml`.

#### Labs
* Introduced advanced Docker networking labs covering bridge network inspection and custom DNS resolution.
* Fixed container cleanup behavior in `tld lab stop` to prevent dangling volume resource leaks.

---

### v1.0.0 — Initial Open Source Release

#### Core System
* Initial release of TLD monorepo containing Go CLI, FastAPI backend, PostgreSQL schema, and Next.js user dashboard.
* Local lab environment runner utilizing Docker Unix socket communication.
* Initial Linux, Docker, and Web Architecture lab tracks.