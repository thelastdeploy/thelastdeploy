---
title: "Quick Start"
description: "Install the CLI and solve your first lab environment."
section: "Getting Started"
---

This guide gets the TLD CLI installed on your machine and walks through running and validating your first lab.

<Callout variant="info" title="No account required to start" text="You can run labs and execute checks locally without signing in. Authenticating with `tld login` is only necessary if you want your completed labs and XP saved to your TLD account." />

## 1. Install the CLI Agent

Run the installation script to download the compiled `tld` binary for your OS and architecture into `/usr/local/bin/tld`:

```bash
curl -fsSL https://install.thelastdeploy.com | sh
```

Verify that the binary is installed and reachable in your PATH:

```bash
tld version
# Expected output: tld version v1.1.0 (linux/amd64)
```

## 2. Verify Your Docker Environment

TLD requires a running Docker daemon. Run `tld doctor` to check if your user account has access to the Docker socket:

```bash
tld doctor
```

If `tld doctor` reports that your user lacks Docker permissions, add your user to the `docker` group:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## 3. List and Start a Lab

List available lab modules:

```bash
tld lab list
```

Start the containerized lab `dkr-fix-stopped-container`:

```bash
tld lab start dkr-fix-stopped-container
```

The CLI pulls necessary container images, sets up isolated container networks, and writes the scenario instructions to `~/.tld/labs/current/README.md`.

## 4. Solve the Incident

Read the lab scenario:

```bash
cat ~/.tld/labs/current/README.md
```

Investigate the containers using standard Docker commands:

```bash
docker ps -a
docker logs <container-id>
```

Apply your fix in the terminal.

## 5. Validate Your Fix

Run `tld check` to execute the scenario assertion script:

```bash
tld check
```

If all checks pass, `tld check` returns exit status 0 and displays passing assertions. If any assertion fails, it reports which check failed so you can continue debugging.