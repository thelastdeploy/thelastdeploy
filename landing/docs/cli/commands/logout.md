---
title: "tld logout"
description: "Remove saved authentication credentials and unpair CLI device."
section: "CLI"
---

`tld logout` removes saved user tokens, device keys, and account metadata from `~/.tld/config.json`.

## Usage

```bash
tld logout
```

## Behavior

* Resets `auth_token`, `device_key`, and `username` in `~/.tld/config.json` to empty strings.
* Does not delete local challenge caches or container images.

## Example

```bash
tld logout
# Output: Cleared local credentials from ~/.tld/config.json
```