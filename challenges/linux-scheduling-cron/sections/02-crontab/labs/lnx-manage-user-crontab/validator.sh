#!/bin/bash
set -euo pipefail

TARGET="$HOME/cron-test/current_crontab.bak"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "0 1 \* \* \* .*find /tmp"; then
    echo "FAIL: $TARGET does not contain expected scheduled job."
    exit 1
fi

echo "PASS: User crontab backup file verified."
exit 0
