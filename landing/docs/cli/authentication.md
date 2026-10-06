---
title: "CLI Authentication"
description: "How the OAuth2 device flow pairs your CLI agent with your TLD account."
section: "CLI"
---

The CLI agent uses the OAuth2 Device Authorization Grant (RFC 8628) to pair your local terminal with your TLD user account. This avoids storing or entering your user password in shell scripts or terminal history.

## Device Authentication Workflow

Run `tld login` in your terminal:

```bash
tld login
```

The CLI requests authorization credentials from the backend API:

```text
==> Initiating CLI device authentication...

1. Open this URL in your browser:
   http://localhost:9000/cli/auth

2. Verify or enter your 8-character device confirmation code:
   CODE: B7A2-9K1F

Waiting for authorization (press Ctrl+C to cancel)...
```

1. The CLI attempts to open `http://localhost:9000/cli/auth` in your default browser.
2. Log in to your TLD account if you are not already authenticated.
3. Confirm that the 8-character code matches `B7A2-9K1F` and click **Authorize CLI Device**.
4. The CLI polls `POST /api/v1/auth/cli/token` until confirmation is received.
5. Upon approval, the server issues an access token and `device_key`. The CLI saves these to `~/.tld/config.json`.

```text
✓ Successfully authenticated as shreyansh@thelastdeploy.com!
Your terminal is now paired with your TLD profile.
```

## Revoking Authorization (`tld logout`)

To remove local credentials and unpair your device:

```bash
tld logout
```

This deletes `auth_token`, `device_key`, and `username` from `~/.tld/config.json`.