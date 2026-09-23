# systemd Core Concepts & Unit Types

`systemd` is the standard init system and service manager for modern Linux distributions. It initializes the user space, manages system processes, handles event activation, and provides unified logging via `journalctl`.

---

## 1. Systemd Unit Types

Everything managed by `systemd` is represented as a **unit**. Unit configuration files end with specific extensions denoting their resource type:

| Unit Extension | Resource Type | Description |
| :--- | :--- | :--- |
| `.service` | Service | Daemon or background process management |
| `.target` | Target | Logical grouping of units (boot runlevels) |
| `.socket` | Socket | IPC socket or network port activation |
| `.timer` | Timer | Scheduled task activation (cron replacement) |
| `.mount` | Mount | Filesystem mount point management |
| `.device` | Device | Kernel device event unit |
| `.slice` | Slice | Cgroup resource management hierarchy |

---

## 2. Inspecting Units with `systemctl`

The `systemctl` command is the primary CLI tool for interacting with the `systemd` daemon:

```bash
# List all active units
systemctl list-units

# List loaded units of type 'service'
systemctl list-units --type=service

# List unit files installed on disk and their enablement state
systemctl list-unit-files --type=service

# View detailed status of a specific unit
systemctl status nginx.service

# Check if a unit is currently active or enabled
systemctl is-active nginx.service
systemctl is-enabled nginx.service
```

---

## Summary

`systemd` unifies process supervision, socket activation, and system state transitions through standardized unit files.

---

## Lab Tasks

### Task 1: Analyze Unit State (`lnx-analyze-unit-state`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-unit-state
   ```
2. Create directory `$HOME/systemd-test`.
3. Run systemctl to list units in a failed state.
4. Output the list of failed units (or line `FAILED_UNITS_CHECKED`) to `$HOME/systemd-test/failed_units.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect systemd Units (`lnx-inspect-systemd-units`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-systemd-units
   ```
2. Create directory `$HOME/systemd-test`.
3. Write commands to inspect systemd unit types and write summary output into `$HOME/systemd-test/units_info.txt`:
4. - Line 1: `SERVICES_COUNT: <number of loaded service units>`
5. - Line 2: `TIMERS_COUNT: <number of loaded timer units>`
6. Validate your solution:
   ```bash
   tld check
   ```
