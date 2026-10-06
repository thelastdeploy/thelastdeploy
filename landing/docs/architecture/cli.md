---
title: "CLI Agent Architecture"
description: "Go CLI agent structure, Docker API integration, and local filesystem state."
section: "Architecture"
---

The CLI agent (`agent/`) is a compiled Go binary (`tld`) built with Cobra. It manages local Docker containers, executes validation scripts, and handles device pairing with the backend API.

## Source Code Organization (`agent/`)

```text
agent/
├── main.go                     # Entry point calling cmd.Execute()
├── cmd/                        # Cobra command flags & handlers
│   ├── root.go                 # Persistent flags (--config, --verbose)
│   ├── start.go                # Lab container & workspace initialization
│   ├── check.go                # Assertion validator runner
│   ├── doctor.go               # System readiness checks
│   ├── login.go                # Device code authentication
│   └── sync.go                 # Manifest cache sync
└── internal/                   # Domain logic
    ├── lab/                    # Docker SDK container & network management
    ├── validator/              # Script execution & output parsing
    ├── config/                 # ~/.tld/config.json manager
    └── device/                 # Hardware UUID generator
```

## Local State Layout (`~/.tld/`)

The CLI maintains state under `~/.tld/` on the user's filesystem:

```text
~/.tld/
├── config.json                 # Auth tokens, API endpoint, device key
├── cache/                      # Module manifests synced from backend
│   └── modules/
└── labs/                       # ACTIVE LAB WORKSPACE
    └── current/
        ├── README.md           # Scenario description and goals
        ├── validator.sh        # Verification assertions
        └── workspace/          # Working directory for user changes
```

## Local Environment Diagnostics (`tld doctor`)

Running `tld doctor` executes four diagnostic checks:

1. **Docker Socket Check:** Tests connection to `/var/run/docker.sock`.
2. **User Group Check:** Verifies user belongs to `docker` group.
3. **Free Storage Check:** Confirms at least 2GB free disk space.
4. **API Reachability:** Sends HTTP GET to API endpoint (`http://localhost:9001` or production URL).