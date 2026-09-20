#!/bin/bash
set -euo pipefail

TARGET="$HOME/cron-test/daily_backup.cron"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "^30 2 \* \* \*"; then
    echo "FAIL: $TARGET must start with the daily 02:30 AM schedule '30 2 * * *'."
    exit 1
fi

echo "PASS: Daily cron expression verified."
exit 0
