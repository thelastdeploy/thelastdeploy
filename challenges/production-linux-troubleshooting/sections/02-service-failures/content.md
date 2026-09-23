# Complex Service Outages & Dependency Chains

In multi-tier production architectures, an application outage is rarely an isolated binary failure. Upstream database crashes, missing environment variables, or broken socket activation dependencies cause cascading failures across dependent services.

---

## 1. Dependency Outage Investigation Flow

```bash
# 1. Identify failing service unit
systemctl status production-app.service

# 2. Inspect exact failure logs in systemd journal
journalctl -u production-app.service -n 50 --no-pager

# 3. Trace unit dependencies to find broken upstream service
systemctl list-dependencies production-app.service --failed
```

---

## 2. Common Service Outage Root Causes

- **Failed Upstream Socket/DB**: App fails to start because database daemon or IPC socket is inactive.
- **Environment & Secret File Typos**: Specified `EnvironmentFile=` contains invalid variables or bad permissions.
- **Stale Lock Files**: Daemon crashed previously and left orphaned lock file or PID file blocking startup.

---

## Summary

Tracing systemd dependency chains (`systemctl list-dependencies --failed`) isolates the primary failing upstream service.

---

## Lab Tasks

### Task 1: Investigate Production Service Outage (`lnx-investigate-service-outage`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-service-outage
   ```
2. Create directory `$HOME/svc-outage-test`.
3. Investigate multi-tier service stack outage using `journalctl` and `systemctl status`.
4. Write output summary line `SERVICE_OUTAGE_DIAGNOSED` to `$HOME/svc-outage-test/outage_diag.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Recover Dependent Service Stack (`lnx-recover-dependent-services`)
1. Start the lab:
   ```bash
   tld start lnx-recover-dependent-services
   ```
2. Create directory `$HOME/svc-outage-test`.
3. Repair broken upstream service dependency and restart application stack.
4. Write output summary `DEPENDENT_STACK_RECOVERED` to `$HOME/svc-outage-test/stack_recovery.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
