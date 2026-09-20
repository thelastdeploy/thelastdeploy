# Automated Maintenance and System Cron

Linux distributions provide system-level cron directories and system crontabs for operating-system maintenance tasks.

## 1. System Cron Directories

Scripts placed in these directories execute automatically without manually editing crontabs (files must be executable `chmod +x` and without file extensions like `.sh` in Debian/Ubuntu):

- `/etc/cron.hourly/`
- `/etc/cron.daily/`
- `/etc/cron.weekly/`
- `/etc/cron.monthly/`

## 2. System-Wide Crontab (`/etc/crontab`)

Unlike user crontabs, `/etc/crontab` includes an additional 6th field specifying the **user context** under which the command executes:

```cron
# m h dom mon dow user  command
0 3 * * * root /usr/local/bin/system_backup.sh
```

## 3. Automated File Pruning

A typical automated maintenance script uses `find` to delete temporary or log files older than a given threshold:

```bash
#!/bin/bash
find /tmp/app_logs -name "*.log" -mtime +14 -delete
echo "[$(date)] Pruned old log files" >> /var/log/maintenance.log
```
