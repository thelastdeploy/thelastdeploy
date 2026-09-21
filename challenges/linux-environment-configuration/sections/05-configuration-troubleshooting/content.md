# Configuration Troubleshooting and Recovery

Misconfigured settings are a leading cause of service startup failures and application downtime.

## 1. Common Configuration Problems

- **Syntax Errors**: Missing quotation marks, bad delimiters, invalid property names.
- **Data Type Mismatches**: Non-integer values assigned to port numbers or connection limits.
- **Missing Required Variables**: Application expects `DB_HOST` or `API_KEY` but environment variable is unset.

## 2. Diagnosing Failures

Always inspect service startup error logs:
```bash
journalctl -u myapp.service -n 50 --no-pager
# or examine log files
tail -n 30 /var/log/myapp/error.log
```

## 3. Restoring Configuration from Backup

When a bad configuration edit causes an outage, restore the last known good backup:

```bash
cp /etc/myapp/app.conf.bak /etc/myapp/app.conf
systemctl restart myapp
```

---

## Lab Tasks

### Task 1: Diagnose Configuration Problems (`lnx-diagnose-configuration-problem`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-configuration-problem
   ```
2. Diagnose invalid application configuration parameters.
3. Create a diagnostic report at `$HOME/env-test/diagnosis.txt` containing `ROOT_CAUSE: INVALID_PORT`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restore Corrupted Configuration from Backup (`lnx-restore-broken-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-restore-broken-configuration
   ```
2. Restore corrupted configuration files from backup.
3. Restore `$HOME/env-test/corrupted_server.conf` using the backup copy `$HOME/env-test/corrupted_server.conf.bak`.
4. Validate your solution:
   ```bash
   tld check
   ```
