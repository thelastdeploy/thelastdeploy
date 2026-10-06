---
title: "Installation & Requirements"
description: "System requirements and installation guide for the TLD CLI agent."
section: "Getting Started"
---

## System Requirements

The TLD CLI agent runs containerized lab environments locally using Docker. Your system must meet these prerequisites:

* **Operating System:** Linux (Ubuntu 20.04+, Debian 11+, Arch, Fedora) or macOS (12+ Monterey on Intel or Apple Silicon). Windows is supported via WSL2.
* **Container Engine:** Docker Engine 24.0+ or Docker Desktop running and accessible via `/var/run/docker.sock`.
* **User Group:** Your user account must belong to the `docker` user group (or have `sudo` access).
* **Storage Space:** At least 2GB of available disk space for scenario image layers.

## Installation

Run the installation script in your terminal:

```bash
curl -fsSL https://install.thelastdeploy.com | sh
```

The script detects your OS and architecture (`amd64` or `arm64`), fetches the matching binary release, and copies it to `/usr/local/bin/tld`.

## Building from Source

If you prefer building from source, ensure you have Go 1.22+ installed:

```bash
git clone https://github.com/thelastdeploy/thelastdeploy.git
cd thelastdeploy
make build
make install
```

## Verification

Run `tld doctor` to verify system compatibility:

```bash
tld doctor
```

Output:

```text
==> Running TLD Environment Diagnostics...
[✓] Docker Daemon: Connected (v25.0.3)
[✓] User Permissions: User 'fsociety' is in docker group
[✓] Available Disk Space: 42.1 GB free
[✓] Network Connectivity: HTTPS to api.thelastdeploy.com OK
[✓] TLD CLI Binary: Version v1.1.0 (linux/amd64)

All checks passed! System is ready to run labs.
```