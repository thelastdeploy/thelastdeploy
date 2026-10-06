---
title: "tld doctor"
description: "Diagnose local system environment, Docker daemon connectivity, and disk space."
section: "CLI"
---

`tld doctor` runs automated diagnostic checks to verify that your system is configured correctly to run TLD lab containers.

## Usage

```bash
tld doctor
```

## Diagnostics Performed

1. **Docker Socket Connection:** Tests read/write access to `/var/run/docker.sock`.
2. **User Group Membership:** Verifies whether the active user belongs to the `docker` group on Linux.
3. **Available Disk Space:** Confirms at least 2GB free storage on the root partition for container image layers.
4. **API Connectivity:** Sends HTTP requests to verify reachability of the TLD backend API endpoint.

## Example Output

```text
==> Running TLD Environment Diagnostics...
[✓] Docker Daemon: Connected (v25.0.3)
[✓] User Permissions: User 'fsociety' is in docker group
[✓] Available Disk Space: 42.1 GB free
[✓] Network Connectivity: HTTPS to api.thelastdeploy.com OK
[✓] TLD CLI Binary: Version v1.1.0 (linux/amd64)

All checks passed! System is ready to run labs.
```