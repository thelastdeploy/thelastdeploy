# systemd Timers & Scheduled Tasks

`systemd` timers are unit files ending in `.timer` that trigger companion `.service` units at specified times or intervals. Timers offer advantages over classic `cron` jobs, including monotonic time triggers, journal logging, and precise process execution controls.

---

## 1. Creating a Timer Unit Pair

A timer setup consists of two files with matching base names:

### Companion Service (`/etc/systemd/system/backup.service`)
```ini
[Unit]
Description=Daily System Backup Task

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

### Timer Unit (`/etc/systemd/system/backup.timer`)
```ini
[Unit]
Description=Run Daily System Backup

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

---

## 2. Timer Commands

```bash
# List all active timers
systemctl list-timers

# Enable and start timer
systemctl enable --now backup.timer
```

---

## Summary

`systemd` timers provide centralized journal integration and flexible calendar expressions for scheduled system automation tasks.

---

## Lab Tasks

### Task 1: Create a systemd Timer Unit (`lnx-create-systemd-timer`)
1. Start the lab:
   ```bash
   tld start lnx-create-systemd-timer
   ```
2. Create directory `$HOME/timer-test`.
3. Create service unit `$HOME/timer-test/maint.service` with `[Unit]`, `[Service]` (`Type=oneshot`, `ExecStart=/bin/echo Maint`).
4. Create matching timer unit `$HOME/timer-test/maint.timer` with `[Unit]`, `[Timer]` (`OnCalendar=daily`, `Persistent=true`), `[Install]` (`WantedBy=timers.target`).
5. Validate your solution:
   ```bash
   tld check
   ```
