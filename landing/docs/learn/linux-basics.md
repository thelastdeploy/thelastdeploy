---
title: "Linux Operating System Basics"
description: "Filesystem hierarchy standard, permission modes, process management, and networking tools."
section: "Learn"
---

## Filesystem Hierarchy Standard (FHS)

Linux organizes files under a single root tree (`/`). Understanding key mount points helps locate configuration files and system logs:

* `/etc`: System-wide configuration files (e.g., `/etc/nginx/nginx.conf`, `/etc/fstab`, `/etc/hosts`).
* `/var/log`: Persistent log storage (e.g., `/var/log/syslog`, `/var/log/nginx/error.log`).
* `/proc`: Virtual filesystem reflecting current kernel state and process memory maps (`/proc/cpuinfo`, `/proc/meminfo`, `/proc/<PID>/`).
* `/sys`: Virtual filesystem exposing kernel devices, cgroups, and module drivers.
* `/usr/bin` & `/bin`: Standard user executable binaries (`ls`, `grep`, `systemctl`).

---

## File Permission Modes

Linux file access is controlled by three permission bits assigned to three target classes:

```text
- rwx r-x r--   1 owner group 4096 Oct 6 12:00 script.sh
  │   │   └── Others: Read only (4)
  │   └────── Group: Read & Execute (4+1=5)
  └────────── Owner: Read, Write & Execute (4+2+1=7)
```

| Bit | Symbol | Value | File Effect | Directory Effect |
| :--- | :--- | :--- | :--- | :--- |
| Read | `r` | `4` | View file contents. | List directory contents (`ls`). |
| Write | `w` | `2` | Edit file contents. | Create/delete files inside directory. |
| Execute | `x` | `1` | Execute script/binary. | Enter directory (`cd`). |

### Mode Modifiers
* `chmod 755 script.sh`: Set `rwxr-xr-x` permissions.
* `chmod 600 config.json`: Set `rw-------` permissions (read/write by owner only).
* `chown appuser:appgroup file.txt`: Change file owner and group.

---

## Process Supervision & Signals

Linux processes communicate using standard OS signals:

* `SIGINT (2)`: Keyboard interrupt (`Ctrl+C`). Asks process to terminate gracefully.
* `SIGTERM (15)`: Standard termination request. Sent by `systemctl stop` or `docker stop`.
* `SIGKILL (9)`: Immediate kernel kill signal. Cannot be intercepted or handled by process code.

### Inspecting Processes
```bash
# View active process tree
ps auxf

# Search for running python processes
pgrep -fl python

# Monitor live CPU and RAM consumption
htop
```