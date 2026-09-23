# Service Failure & Crash Analysis

When a systemd service fails to start or crashes unexpectedly, system administrators must correlate unit status messages, journal entries, and system permission states to isolate the root cause.

---

## 1. Diagnostic Investigation Workflow

```bash
# 1. View high-level unit status and failure summary
systemctl status broken-app.service

# 2. Inspect exact stdout/stderr log output from systemd journal
journalctl -u broken-app.service -n 50 --no-pager

# 3. Verify unit syntax for errors
systemd-analyze verify /etc/systemd/system/broken-app.service
```

---

## 2. Common Service Failure Causes

- **Missing Binary or Bad ExecStart Path**: Command specified in `ExecStart=` does not exist or lacks execute (`+x`) permissions.
- **Unreadable EnvironmentFile**: Specified `EnvironmentFile=` path is missing or inaccessible.
- **Port Conflict**: Process attempts to bind to a TCP/UDP port already used by another daemon.
- **User/Group Permissions**: Specified `User=` lacks read/write access to `WorkingDirectory=` or log paths.

---

## Summary

Diagnostic tools like `systemctl status`, `journalctl -u`, and `systemd-analyze verify` provide comprehensive details for repairing failed services.

---

## Lab Tasks

### Task 1: Diagnose Failed Service (`lnx-diagnose-failed-service`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-failed-service
   ```
2. Create directory `$HOME/fail-test`.
3. Inspect sample broken service unit `$HOME/fail-test/broken.service` (which references non-existent path `/bin/missing_binary`).
4. Write diagnosis line `REASON: missing_executable` into `$HOME/fail-test/diag_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Recover Service Startup (`lnx-recover-service-startup`)
1. Start the lab:
   ```bash
   tld start lnx-recover-service-startup
   ```
2. Inspect `$HOME/fail-test/broken.service`.
3. Repair `ExecStart` path to point to valid executable `/bin/echo Service Restored`.
4. Save repaired unit file to `$HOME/fail-test/fixed.service`.
5. Validate your solution:
   ```bash
   tld check
   ```
