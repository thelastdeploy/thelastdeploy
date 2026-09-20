#!/bin/bash
set -euo pipefail

TARGET="$HOME/cron-test/sys_crontab"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "^0 3 \* \* \* root /usr/local/bin/sys_maint\.sh"; then
    echo "FAIL: $TARGET must contain '0 3 * * * root /usr/local/bin/sys_maint.sh'."
    exit 1
fi

echo "PASS: System-wide crontab entry verified."
exit 0
