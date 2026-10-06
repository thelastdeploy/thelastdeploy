---
title: "Updating TLD"
description: "How to update the CLI agent and refresh local challenge manifests."
section: "Getting Started"
---

## Updating the CLI Agent

To update your local binary to the latest release:

```bash
tld update
```

Alternatively, re-run the installation script:

```bash
curl -fsSL https://install.thelastdeploy.com | sh
```

Verify the updated version:

```bash
tld version
```

## Refreshing Local Challenge Cache

To fetch the latest module manifests and scenario updates from the backend API:

```bash
tld sync
```

This updates the manifest cache stored under `~/.tld/cache/`.