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
2. Inspect the application error log at `$HOME/env-test/app_error.log` and the corresponding configuration file at `$HOME/env-test/broken_app.conf`.
3. Identify the invalid parameter and record your findings by writing `ROOT_CAUSE: INVALID_PORT` into `$HOME/env-test/diagnosis.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restore Corrupted Configuration from Backup (`lnx-restore-broken-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-restore-broken-configuration
   ```
2. Inspect the corrupted file `$HOME/env-test/corrupted_server.conf` and its valid backup copy `$HOME/env-test/corrupted_server.conf.bak`.
3. Restore `$HOME/env-test/corrupted_server.conf` from `$HOME/env-test/corrupted_server.conf.bak`.
4. Validate your solution:
   ```bash
   tld check
   ```
