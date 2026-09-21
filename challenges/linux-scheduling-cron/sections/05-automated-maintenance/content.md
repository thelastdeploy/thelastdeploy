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

---

## Lab Tasks

### Task 1: Automate Directory Cleanup and Logging (`lnx-automate-file-cleanup`)
1. Start the lab:
   ```bash
   tld start lnx-automate-file-cleanup
   ```
2. Automate maintenance cleanup tasks via scripts.
3. Create an executable cleanup script at `$HOME/cron-test/cleanup_job.sh` removing temporary log files and logging output to `$HOME/cron-test/cleanup.log`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Configure System-Wide Crontab Maintenance (`lnx-schedule-system-maintenance`)
1. Start the lab:
   ```bash
   tld start lnx-schedule-system-maintenance
   ```
2. Configure system-wide `/etc/crontab` maintenance jobs.
3. Create a system crontab snippet at `$HOME/cron-test/sys_crontab` including the user field `root` before command execution.
4. Validate your solution:
   ```bash
   tld check
   ```
