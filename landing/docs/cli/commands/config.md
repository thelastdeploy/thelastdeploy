---
title: "tld config"
description: "Inspect or modify CLI settings in ~/.tld/config.json."
section: "CLI"
---

`tld config` reads and writes key-value configuration pairs stored in `~/.tld/config.json`.

## Subcommands

### `tld config show`
Displays current configuration key-value pairs stored in `~/.tld/config.json`.

```bash
tld config show
```

### `tld config set <key> <value>`
Sets a configuration key (e.g., `api_url`).

```bash
tld config set api_url http://localhost:9001
```