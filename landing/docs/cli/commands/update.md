---
title: "tld update"
description: "Check for and install CLI binary updates."
section: "CLI"
---

`tld update` checks the GitHub release API for newer versions of the CLI agent and replaces the binary at `/usr/local/bin/tld`.

## Usage

```bash
tld update
```

## Flags

* `--check-only`: Check if an update is available without replacing the binary.
* `-h, --help`: Display command usage help.