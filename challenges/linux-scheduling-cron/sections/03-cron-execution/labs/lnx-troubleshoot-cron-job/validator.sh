#!/bin/bash
set -euo pipefail

TARGET="$HOME/cron-test/broken_crontab"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "PATH="; then
    echo "FAIL: $TARGET must explicitly define 'PATH=' near top."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "/usr/local/bin/backup.sh"; then
    echo "FAIL: $TARGET must use absolute path '/usr/local/bin/backup.sh'."
    exit 1
fi

echo "PASS: Cron environment troubleshooting verified."
exit 0
