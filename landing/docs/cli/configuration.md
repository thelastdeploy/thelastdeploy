---
title: "CLI Configuration & Environment Variables"
description: "~/.tld/config.json schema and environment variable overrides."
section: "CLI"
---

The CLI agent reads configuration settings from `~/.tld/config.json`. Settings can also be overridden using environment variables.

## File Schema (`~/.tld/config.json`)

```json
{
  "api_url": "http://localhost:9001",
  "auth_token": "eyJhbGciOiJIUzI1Ni...",
  "device_key": "dev_key_8f91a2b4c5d6e7f8",
  "username": "shreyansh"
}
```

## Keys

| Key | Default Value | Description |
| :--- | :--- | :--- |
| `api_url` | `http://localhost:9001` | Base URL of the TLD backend API. |
| `auth_token` | `""` | JWT access token issued during `tld login`. |
| `device_key` | `""` | Hardware key generated during device pairing. |
| `username` | `""` | Currently authenticated account username. |

## Environment Variables

Environment variables take precedence over settings in `~/.tld/config.json`:

* `TLD_API_URL`: Override the backend API server URL (e.g. `export TLD_API_URL="https://api.thelastdeploy.com"`).
* `TLD_LOG_LEVEL`: Set log verbosity (`debug`, `info`, `warn`, `error`).
* `NO_COLOR`: Disable colorized ANSI output in terminal responses.