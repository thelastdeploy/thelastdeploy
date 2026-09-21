# Task Scheduling Capstone Challenge

In this final capstone challenge, you will troubleshoot and repair a broken scheduled system maintenance setup.

## Challenge Tasks

1. **Fix Crontab File**: Edit `$HOME/cron-challenge/maint.crontab`:
   - Set `PATH=/usr/local/bin:/usr/bin:/bin` near the top of the file.
   - Fix the broken schedule so it runs daily at 02:00 AM (`0 2 * * *`).
   - Use the full absolute path `$HOME/cron-challenge/maint_script.sh`.
   - Redirect standard output and standard error to `$HOME/cron-challenge/maint.log` (`>> $HOME/cron-challenge/maint.log 2>&1`).
2. **Fix Script Permissions**: Ensure `$HOME/cron-challenge/maint_script.sh` is executable (`chmod +x`).
3. **Status Report**: Output a status verification file at `$HOME/cron-challenge/status.txt` containing `CRON_RECOVERY_SUCCESS`.

---

## Lab Tasks

### Task 1: Repair Scheduled System Maintenance Setup (`lnx-repair-scheduled-maintenance`)
1. Start the lab:
   ```bash
   tld start lnx-repair-scheduled-maintenance
   ```
2. Complete the task scheduling capstone challenge.
3. Repair `$HOME/cron-challenge/maint.crontab`, fix `$HOME/cron-challenge/maint_script.sh`, and record `SCHEDULE_STATUS: ACTIVE` in `$HOME/cron-challenge/status.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
