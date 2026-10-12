---
title: "Updating TLD"
description: "How to update the CLI agent and refresh local challenge manifests."
section: "Getting Started"
---

## Updating the CLI Agent

To update your local binary to the latest release:

```bash
# Update to latest stable release
tld update

# Update to latest bleeding-edge build from main
tld update --edge

# Check if an update is available without installing
tld update --check

# Target a specific version
tld update --version v1.1.2
```

> [!NOTE]
> If installed globally under `/usr/local/bin`, run with elevated privileges: `sudo tld update`.

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