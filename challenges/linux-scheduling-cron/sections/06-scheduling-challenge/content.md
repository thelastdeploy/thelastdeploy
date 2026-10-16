# Task Scheduling Capstone Challenge

In this final capstone challenge, you will troubleshoot and repair a broken scheduled system maintenance setup.

## Challenge Tasks

1. **Fix Crontab File**: Edit `$HOME/cron-challenge/maint.crontab`:
   - Set a reliable `PATH` variable (`PATH=/usr/local/bin:/usr/bin:/bin`) near the top of the file so cron can locate standard system binaries.
   - Fix the invalid schedule expression so the job runs daily at 02:00 AM.
   - Specify the absolute path to `$HOME/cron-challenge/maint_script.sh`.
   - Append standard output and redirect standard error to `$HOME/cron-challenge/maint.log` using `>>` and `2>&1`.
2. **Fix Script Permissions**: Ensure `$HOME/cron-challenge/maint_script.sh` has execute permissions.
3. **Status Report**: Write `CRON_RECOVERY_SUCCESS` to `$HOME/cron-challenge/status.txt` to confirm recovery completion.

---

## Lab Tasks

### Task 1: Repair Scheduled System Maintenance Setup (`lnx-repair-scheduled-maintenance`)
1. Start the lab:
   ```bash
   tld start lnx-repair-scheduled-maintenance
   ```
2. Inspect the misconfigured crontab file at `$HOME/cron-challenge/maint.crontab` and review existing errors.
3. Update the schedule to run daily at 02:00 AM, reference `$HOME/cron-challenge/maint_script.sh`, configure redirection, and ensure appropriate `PATH` settings.
4. Make `$HOME/cron-challenge/maint_script.sh` executable.
5. Create `$HOME/cron-challenge/status.txt` containing `CRON_RECOVERY_SUCCESS`.
6. Validate your solution:
   ```bash
   tld check
   ```
