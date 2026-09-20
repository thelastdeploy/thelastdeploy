#!/bin/bash
set -euo pipefail

CRONTAB_FILE="$HOME/cron-challenge/maint.crontab"
SCRIPT_FILE="$HOME/cron-challenge/maint_script.sh"
STATUS_FILE="$HOME/cron-challenge/status.txt"

# 1. Check Crontab File
if [ ! -f "$CRONTAB_FILE" ]; then
    echo "FAIL: $CRONTAB_FILE does not exist."
    exit 1
fi

CRON_CONTENT=$(cat "$CRONTAB_FILE")

if ! echo "$CRON_CONTENT" | grep -q "PATH="; then
    echo "FAIL: $CRONTAB_FILE missing 'PATH=' environment setting."
    exit 1
fi

if ! echo "$CRON_CONTENT" | grep -Eq "^0 2 \* \* \*"; then
    echo "FAIL: $CRONTAB_FILE does not contain valid 02:00 AM schedule '0 2 * * *'."
    exit 1
fi

if ! echo "$CRON_CONTENT" | grep -q "maint_script.sh"; then
    echo "FAIL: $CRONTAB_FILE does not reference maint_script.sh."
    exit 1
fi

if ! echo "$CRON_CONTENT" | grep -q "2>&1"; then
    echo "FAIL: $CRONTAB_FILE missing stderr redirection '2>&1'."
    exit 1
fi

# 2. Check Script Executable
if [ ! -x "$SCRIPT_FILE" ]; then
    echo "FAIL: $SCRIPT_FILE is not executable. Use 'chmod +x'."
    exit 1
fi

# 3. Check Status File
if [ ! -f "$STATUS_FILE" ]; then
    echo "FAIL: Status report file $STATUS_FILE does not exist."
    exit 1
fi

if ! grep -q "CRON_RECOVERY_SUCCESS" "$STATUS_FILE"; then
    echo "FAIL: $STATUS_FILE does not contain 'CRON_RECOVERY_SUCCESS'."
    exit 1
fi

echo "PASS: Scheduled maintenance repair capstone challenge verified."
exit 0
