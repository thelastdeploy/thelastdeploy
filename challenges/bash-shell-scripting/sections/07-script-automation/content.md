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
