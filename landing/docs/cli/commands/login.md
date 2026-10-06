---
title: "tld login"
description: "Authenticate the CLI agent using OAuth2 device authorization."
section: "CLI"
---

`tld login` pairs your terminal CLI agent with your TLD account without requiring you to enter password credentials in the command line.

## Usage

```bash
tld login
```

## How It Works

1. The CLI calls `POST /api/v1/auth/cli/device-code` to request a device code and a 8-character user code from the TLD backend API.
2. The CLI prints the user code and attempts to open your default browser to `http://localhost:9000/cli/auth` (or production authentication URL).
3. The CLI polls `POST /api/v1/auth/cli/token` in the background waiting for authorization.
4. Once you click **Authorize** in the web browser, the server returns an access token and `device_key`.
5. The CLI writes the credentials to `~/.tld/config.json`.

## Configuration Stored

When login succeeds, `~/.tld/config.json` is updated with:

```json
{
  "api_url": "http://localhost:9001",
  "auth_token": "eyJhbGciOiJIUzI1Ni...",
  "device_key": "dev_key_8f91a2b4c5d6e7f8",
  "username": "shreyansh"
}
```

## Flags

* `--api-url <url>`: Override the default backend API endpoint URL.
* `-h, --help`: Display command usage help.