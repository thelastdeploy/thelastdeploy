# Safe Reruns & Idempotent Automation

In infrastructure automation, an idempotent script produces the exact same system state regardless of how many times it is executed. Idempotency prevents configuration duplication, state corruption, and unexpected downtime during automated reruns.

---

## 1. State Verification Before Mutation

Before appending data or modifying configurations, verify if the desired state already exists:

```bash
CONFIG_FILE="/etc/app/config.conf"
ENTRY="MAX_WORKERS=10"

# Check if entry already exists
if ! grep -q "^$ENTRY" "$CONFIG_FILE"; then
    echo "$ENTRY" >> "$CONFIG_FILE"
    echo "Updated configuration."
else
    echo "Configuration already up to date."
fi
```

---

## 2. Atomic File Swaps & Lock Files

Prevent partial writes and concurrent race conditions by writing to temporary files and performing atomic file swaps:

```bash
TEMP_CONF=$(mktemp)

# Generate new configuration
generate_config > "$TEMP_CONF"

# Atomic swap
mv "$TEMP_CONF" /etc/app/config.conf
```

Use `flock` to ensure only one instance of an automation script runs simultaneously:

```bash
exec 200>/var/run/my_automation.lock
flock -n 200 || { echo "Another instance is running. Exiting."; exit 1; }
```

---

## Summary

Combining pre-mutation state checks with atomic file operations ensures scripts remain idempotent and safe for repeated automated execution.

---

## Lab Tasks

### Task 1: Build an Idempotent Automation Script (`lnx-build-idempotent-script`)
1. Start the lab:
   ```bash
   tld start lnx-build-idempotent-script
   ```
2. Create directory `$HOME/idempotent-test` and seed `$HOME/idempotent-test/app.conf` with `MAX_CONNECTIONS=100`.
3. Write executable script `$HOME/idempotent-test/deploy.sh` that:
4. - Sets `TIMEOUT=30` and updates `MAX_CONNECTIONS=200` in `app.conf`.
5. - Ensures running `deploy.sh` multiple times produces exact same `app.conf` without duplicate lines.
6. Execute `deploy.sh` twice.
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Protect Automation with Lock Files and Atomic Swaps (`lnx-protect-automation-from-failure`)
1. Start the lab:
   ```bash
   tld start lnx-protect-automation-from-failure
   ```
2. Create directory `$HOME/atomic-test`.
3. Write executable script `$HOME/atomic-test/safe_update.sh` that:
4. - Uses a lock file `$HOME/atomic-test/script.lock` to prevent concurrent runs.
5. - Writes updated data to temporary file first before atomically replacing `$HOME/atomic-test/target.txt` (`mv temp file target.txt`).
6. Execute `$HOME/atomic-test/safe_update.sh`.
7. Validate your solution:
   ```bash
   tld check
   ```
