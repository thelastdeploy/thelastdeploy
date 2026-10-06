---
title: "tld lab"
description: "Manage lab scenario lifecycles (list, start, stop, status)."
section: "CLI"
---

`tld lab` provisions, inspects, and tears down containerized lab environments on your local machine.

## Subcommands

### `tld lab list`
Displays all available learning modules, tracks, and lab IDs.

```bash
tld lab list
```

### `tld lab start <id>`
Provisions Docker containers, creates bridge network `tld-net-<id>`, and extracts scenario instructions to `~/.tld/labs/current/`.

```bash
tld lab start dkr-fix-stopped-container
```

### `tld lab stop`
Stops running lab containers, purges container bridge networks, and cleans up `~/.tld/labs/current/workspace/`.

```bash
tld lab stop
```

### `tld lab status`
Displays the running state of containers and active workspace paths for the current lab.

```bash
tld lab status
```