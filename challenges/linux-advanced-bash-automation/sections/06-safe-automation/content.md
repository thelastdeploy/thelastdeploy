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
2. Create directory `$HOME/idempotent-test` and seed initial configuration:
   ```bash
   mkdir -p ~/idempotent-test
   echo "MAX_CONNECTIONS=100" > ~/idempotent-test/app.conf
   ```
3. Create the idempotent script `$HOME/idempotent-test/deploy.sh`:
   ```bash
   cat << 'EOF' > ~/idempotent-test/deploy.sh
   #!/bin/bash
   set -euo pipefail

   CONF="$HOME/idempotent-test/app.conf"

   if grep -q "^MAX_CONNECTIONS=" "$CONF"; then
       sed -i 's/^MAX_CONNECTIONS=.*/MAX_CONNECTIONS=200/' "$CONF"
   else
       echo "MAX_CONNECTIONS=200" >> "$CONF"
   fi

   if ! grep -q "^TIMEOUT=" "$CONF"; then
       echo "TIMEOUT=30" >> "$CONF"
   fi
   EOF
   chmod +x ~/idempotent-test/deploy.sh
   ```
4. Execute `deploy.sh` twice to verify idempotency:
   ```bash
   ~/idempotent-test/deploy.sh
   ~/idempotent-test/deploy.sh
   cat ~/idempotent-test/app.conf
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Protect Automation with Lock Files and Atomic Swaps (`lnx-protect-automation-from-failure`)
1. Start the lab:
   ```bash
   tld start lnx-protect-automation-from-failure
   ```
2. Create directory `$HOME/atomic-test` and seed the initial target file:
   ```bash
   mkdir -p ~/atomic-test
   echo "initial_data" > ~/atomic-test/target.txt
   ```
3. Create the script `$HOME/atomic-test/safe_update.sh`:
   ```bash
   cat << 'EOF' > ~/atomic-test/safe_update.sh
   #!/bin/bash
   set -euo pipefail

   LOCKFILE="$HOME/atomic-test/script.lock"
   TARGET="$HOME/atomic-test/target.txt"

   exec 200>"$LOCKFILE"
   flock -n 200 || { echo "Script is already running"; exit 1; }

   TMPFILE=$(mktemp "$HOME/atomic-test/tmp.XXXXXX")
   echo "updated_data_$(date +%s)" > "$TMPFILE"
   mv "$TMPFILE" "$TARGET"
   EOF
   chmod +x ~/atomic-test/safe_update.sh
   ```
4. Execute `safe_update.sh`:
   ```bash
   ~/atomic-test/safe_update.sh
   cat ~/atomic-test/target.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

