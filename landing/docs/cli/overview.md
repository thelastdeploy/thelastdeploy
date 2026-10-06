---
title: "CLI Overview & Quick Reference"
description: "CLI agent architecture, installation methods, and core subcommand reference."
section: "CLI"
---

The TLD CLI (`tld`) is a Go binary that manages local Docker lab containers, executes assertion validators, and syncs progress to your account.

## Installation

Install the compiled binary directly:

```bash
curl -fsSL https://install.thelastdeploy.com | sh
```

Or build from source using Go 1.22+:

```bash
git clone https://github.com/thelastdeploy/thelastdeploy.git
cd thelastdeploy
make install
```

The Makefile compiles `agent/main.go` and places the output binary at `/usr/local/bin/tld`.

## Command Reference

| Command | Usage | Behavior |
| :--- | :--- | :--- |
| `tld login` | `tld login` | Initiates OAuth2 device authorization and saves access tokens to `~/.tld/config.json`. |
| `tld logout` | `tld logout` | Deletes auth tokens and device keys from `~/.tld/config.json`. |
| `tld lab list` | `tld lab list` | Fetches and displays available tracks, modules, and lab IDs. |
| `tld lab start` | `tld lab start <id>` | Pulls images, provisions containers, and creates workspace files in `~/.tld/labs/current/`. |
| `tld lab stop` | `tld lab stop` | Stops running lab containers and removes temporary network bridges. |
| `tld check` | `tld check` | Runs `validator.sh` in the active lab context and reports assertion results. |
| `tld status` | `tld status` | Displays state of running lab containers and workspace paths. |
| `tld doctor` | `tld doctor` | Checks Docker socket access, disk space, and API connectivity. |
| `tld sync` | `tld sync` | Refreshes the local challenge cache in `~/.tld/cache/`. |
| `tld version` | `tld version` | Prints binary version, OS/architecture, and build commit. |