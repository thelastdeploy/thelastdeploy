#!/bin/bash
set -euo pipefail

TARGET="$HOME/cron-test/my_cron.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "^0 \* \* \* \* .*audit\.sh.*(>>|>).*2>&1"; then
    echo "FAIL: $TARGET must contain hourly schedule '0 * * * *', run audit.sh, and redirect stderr ('2>&1')."
    exit 1
fi

echo "PASS: Recurring task schedule entry with output redirection verified."
exit 0
