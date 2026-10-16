# Script Automation and Maintenance

System maintenance scripts automate routine administrative chores such as removing obsolete files, backing up databases, checking disk health, and generating reports.

## 1. Timestamps and Log Auditing

Use `date` with formatting strings to generate timestamps for logs and filenames:
```bash
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
echo "[$TIMESTAMP] Maintenance task started." >> /var/log/maintenance.log
```

## 2. Finding and Pruning Files

The `find` command can locate and clean up files matching specific age or pattern criteria:
```bash
# Find and delete log files older than 7 days
find /var/log/app -name "*.log" -mtime +7 -delete
```

## 3. Automation best practices

- Log all operations with precise timestamps.
- Validate paths before deleting files to prevent accidental data loss.
- Always check exit codes before logging success.

---

## Lab Tasks

### Task 1: Automate System Maintenance and Logging (`lnx-automate-system-maintenance`)
1. Start the lab:
   ```bash
   tld start lnx-automate-system-maintenance
   ```
2. Create an executable system maintenance script at `$HOME/script-test/clean_old_logs.sh`.
3. The script should delete all obsolete `.old` files inside `$HOME/script-test/active_logs/` (while leaving active `.log` files untouched).
4. Append a timestamped log entry containing `CLEANUP_COMPLETE` to `$HOME/script-test/maintenance.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
