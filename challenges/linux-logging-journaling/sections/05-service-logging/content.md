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
