## Restore Connectivity

In production, misconfigured networks or containers connected to the wrong driver (like `none`) can sever communication entirely, crashing web services. Resolving these requires diagnostic skills and knowledge of network commands.

---

## 1. Network Diagnostics

When troubleshooting network connectivity issues:

1. **Verify network list**: Run `docker network ls` to inspect available interfaces.
2. **Inspect container networks**: Run `docker inspect <container>` and look at `NetworkSettings.Networks`. If you see only `none` or empty mappings, the container is disconnected.
3. **Connect dynamically**: Use `docker network connect <network> <container>` to bridge it back to the required network workspace.

---

## Lab Tasks

### Task 1: Fix broken container network (`dkr-fix-broken-container-network`)
1. Start the lab session:
   ```bash
   tld start dkr-fix-broken-container-network
   ```
2. A running container named `broken-web` was started with the `none` network driver and cannot communicate on `web-net`. Disconnect the container from `none` and connect it to the `web-net` custom network:
   ```bash
   docker network disconnect none broken-web
   docker network connect web-net broken-web
   ```
3. Verify that `broken-web` is attached to `web-net`:
   ```bash
   docker inspect broken-web --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}'
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
