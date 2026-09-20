#!/bin/bash
set -euo pipefail

TARGET="$HOME/cron-test/step_schedule.cron"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "^\*/15 \* \* \* \*"; then
    echo "FAIL: $TARGET must start with step schedule '*/15 * * * *'."
    exit 1
fi

echo "PASS: Step schedule cron entry verified."
exit 0
