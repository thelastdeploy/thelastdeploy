---
title: "Troubleshooting Guide"
description: "Diagnosing common environment errors, socket permissions, and container conflicts."
section: "Getting Started"
---

This page covers solutions for common errors encountered when starting or validating TLD labs.

## 1. `permission denied while trying to connect to the Docker daemon socket`

**Symptom:** Running `tld lab start` or `tld doctor` fails with permission errors accessing `/var/run/docker.sock`.

**Cause:** Your user account does not belong to the `docker` system group on Linux.

**Fix:** Add your user to the `docker` group and apply the group change:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Verify access by running `docker ps` without `sudo`.

---

## 2. `tld check` fails with `validator script missing`

**Symptom:** Running `tld check` reports that `validator.sh` cannot be found.

**Cause:** The active workspace in `~/.tld/labs/current/` was deleted or interrupted during provisioning.

**Fix:** Stop the lab and re-initialize the environment:

```bash
tld lab stop
tld lab start <lab-id>
```

---

## 3. Container Port Conflict (`port is already allocated`)

**Symptom:** Starting a lab fails because a required port (e.g., 80 or 5432) is already in use on your host machine.

**Cause:** Another local service (like local Nginx or PostgreSQL) is listening on the port.

**Fix:** Identify which process is bound to the port and stop it:

```bash
sudo netstat -tulpn | grep :80
# Or inspect running Docker containers
docker ps
```