# Service Lifecycle & Runtime State

Managing services requires understanding the distinction between **runtime execution state** (active vs inactive) and **boot-time startup configuration** (enabled vs disabled).

---

## 1. Runtime Execution Control

Runtime control commands immediately affect running processes without modifying boot configuration:

```bash
# Start a stopped service
systemctl start cron.service

# Stop a running service
systemctl stop cron.service

# Restart a service (stop then start)
systemctl restart cron.service

# Reload configuration without restarting process (if supported)
systemctl reload nginx.service
```

---

## 2. Boot-Time Enablement Control

Enabling or disabling a service creates or removes symbolic links in `/etc/systemd/system/`:

```bash
# Enable a service to start at boot
systemctl enable cron.service

# Disable a service from starting at boot
systemctl disable cron.service

# Enable and start in a single command
systemctl enable --now cron.service
```

---

## Summary

Runtime state (`start`/`stop`) modifies active processes immediately, whereas boot state (`enable`/`disable`) manages system initialization behavior.

---

## Lab Tasks

### Task 1: Control Service Boot Startup (`lnx-control-service-startup`)
1. Start the lab:
   ```bash
   tld start lnx-control-service-startup
   ```
2. Create directory `$HOME/service-test`.
3. Check if unit `systemd-journald.service` or `cron.service` is enabled at boot using `systemctl is-enabled`.
4. Write output `ENABLE_STATE: <enabled/static/disabled>` to `$HOME/service-test/boot_state.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Service Lifecycle (`lnx-manage-service-lifecycle`)
1. Start the lab:
   ```bash
   tld start lnx-manage-service-lifecycle
   ```
2. Create directory `$HOME/service-test`.
3. Inspect status of active system service `cron` (or `systemd-journald`).
4. Write active status output line `SERVICE_STATUS: active` into `$HOME/service-test/lifecycle_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
