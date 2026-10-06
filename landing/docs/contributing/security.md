---
title: "Security Policy"
description: "Vulnerability reporting, local sandboxing boundaries, and security practices for TLD."
section: "Contributing"
---

## Reporting Vulnerabilities

If you discover a security vulnerability in the TLD CLI, backend API, authentication system, or container runner engine:

> [!IMPORTANT]
> **Do not open a public GitHub issue or discuss unpatched vulnerabilities in public Discord channels.**

Email details to `security@thelastdeploy.com` or submit a private security advisory via the TLD GitHub repository.

### Information to include

* Description of the vulnerability and its potential impact.
* Exact steps to reproduce the issue (commands, environment variables, payload examples).
* Affected components (`tld-cli`, `web/backend`, Docker host execution, JWT validation).
* Proof-of-concept code or terminal transcripts, if available.

We acknowledge receipt within 48 hours and provide status updates as patches are developed and tested.

## TLD Sandbox Security & Isolation

TLD executes real Docker containers on local developer hardware and isolated lab hosts. When authoring or inspecting labs, keep the following security boundaries in mind:

### Docker Socket Access
* TLD CLI communicates with local Docker daemon over Unix socket (`/var/run/docker.sock`) or TCP host.
* Lab containers must not mount `/var/run/docker.sock` into the container unless the lab explicitly requires nested Docker orchestration (e.g., Docker-in-Docker labs).
* Verification commands executed during `tld check` run inside container namespaces or via controlled `docker exec` calls, preventing host root escalation.

### Auth Tokens & Local Storage
* JWT access tokens and local configurations are saved in `~/.tld/config.json` with standard OS file permissions (`0600`).
* Avoid committing hardcoded tokens, API keys, or database credentials into lab definition files or Git source code.
* Environment overrides rely on standard process environment variables (`TLD_API_URL`, `TLD_TOKEN`).

## Supported Versions

Security updates are issued for the latest minor release of TLD CLI and backend components.

| Component | Version | Security Support |
| :--- | :--- | :--- |
| TLD CLI | `>= 0.1.0` | Active support |
| Backend API | `main` branch | Active support |
| Lab Engine | `>= 0.1.0` | Active support |