---
title: "Lab Engine & Container Isolation"
description: "How TLD provisions isolated Docker networks, containers, and programmatic validator scripts."
section: "Architecture"
---

The Lab Engine (`agent/internal/lab/` and `agent/internal/validator/`) provisions containerized lab environments on your local host using the official Docker Go SDK.

## Container Network Isolation

When `tld lab start <id>` runs, the engine creates a dedicated Docker bridge network:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DOCKER HOST ENVIRONMENT                            │
│                                                                             │
│   Isolated Bridge Network: tld-net-<lab-id>                                 │
│   ┌───────────────────────────┐         ┌───────────────────────────────┐   │
│   │   Target Container        │         │   Auxiliary Container         │   │
│   │   (e.g., Nginx Server)    │ <─────> │   (e.g., Postgres / Redis)    │   │
│   │   Ports: 80 (Internal)    │         │   Ports: 5432 (Internal)      │   │
│   └─────────────▲─────────────┘         └───────────────────────────────┘   │
│                 │                                                           │
│                 │ Exec / Local Socket Assertion                             │
│   ┌─────────────┴─────────────┐                                             │
│   │   Validator Execution     │                                             │
│   │   (validator.sh)          │                                             │
│   └───────────────────────────┘                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Isolation Rules

1. **Bridge Sandboxing:** Containers run inside `tld-net-<lab-id>`. Direct external host access is blocked unless explicitly declared in `lab.yaml`.
2. **Resource Capping:** Containers enforce CPU limits (e.g., 1.0 CPU) and memory caps (e.g., 512MB RAM) specified in manifest limits.
3. **Workspace Cleanup:** Running `tld lab stop` purges all containers, networks, and temporary volumes associated with the lab.

## Verification Pipeline (`tld check`)

When you run `tld check`:

1. The CLI executes `~/.tld/labs/current/validator.sh`.
2. The script outputs check progress formatted as `CHECK_ID|STATUS|MESSAGE`.
3. If all assertions exit with status 0, the CLI sends the verification payload to `POST /api/v1/results/check` to credit XP to your account.
4. If any check fails (non-zero exit code), `tld check` outputs the failing step and message without crediting XP.