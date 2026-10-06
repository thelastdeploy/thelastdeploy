---
title: "CLI Usage Examples"
description: "Practical terminal examples for common TLD workflows."
section: "CLI"
---

This page demonstrates common workflows when using the TLD CLI.

## Workflow 1: Checking System Readiness

Before running labs, verify Docker daemon connectivity and user permissions:

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

## Workflow 2: Starting and Solving a Challenge

List available lab modules:

```bash
tld lab list
```

Start the File Permissions challenge:

```bash
tld lab start lnx-file-permissions
```

Change into the workspace directory:

```bash
cd ~/.tld/labs/current/workspace
```

Inspect file permissions:

```bash
ls -la deploy.sh
# -rw-r--r-- 1 fsociety fsociety 84 Oct 6 12:00 deploy.sh
```

Apply executable permissions:

```bash
chmod +x deploy.sh
```

Validate your solution:

```bash
tld check
```

## Workflow 3: Cleaning Up Active Containers

Stop active lab containers and purge the current workspace:

```bash
tld lab stop
```