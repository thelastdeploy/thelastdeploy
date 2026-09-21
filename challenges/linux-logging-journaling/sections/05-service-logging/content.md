# Service Logging and Failure Investigation

When a system service crashes or fails to start, systemd logs provide the exact diagnostic clues needed to resolve the incident.

## 1. Correlating Service Status with Journal Logs

Running `systemctl status service_name` prints the current process state along with the most recent lines of journal log output:

```bash
systemctl status nginx.service
```

If the service status is `failed` (e.g. `Active: failed (Result: exit-code)`), jump directly to the unit's journal log using the `-e` (jump to end) flag:

```bash
journalctl -u nginx.service -e
```

## 2. Investigating Service Crash Causes

Common service failure indicators in logs:
- **Port Conflicts**: `Failed to bind to 0.0.0.0:80: Address already in use`.
- **Permission Errors**: `Permission denied while opening /var/run/app.pid`.
- **Config Syntax Errors**: `Configuration file /etc/app/config.yaml line 14: invalid key`.
- **Out of Memory (OOM)**: Kernel OOM killer invoked on process ID.

---

## Lab Tasks

### Task 1: Correlate Service Status with Journal Logs (`lnx-correlate-service-logs`)
1. Start the lab:
   ```bash
   tld start lnx-correlate-service-logs
   ```
2. Correlate failing systemd service units with log messages.
3. Save the failing service unit name (`payment-processor.service`) to `$HOME/log-test/failing_unit.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Failed Service Crash Logs (`lnx-investigate-failed-service`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-failed-service
   ```
2. Investigate root cause of service startup failures.
3. Save the root cause failure message (`Port 5432 already in use`) to `$HOME/log-test/service_root_cause.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
