#!/bin/bash
set -euo pipefail

TARGET="$HOME/env-test/corrupted_server.conf"
BAK="$HOME/env-test/corrupted_server.conf.bak"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -f "$BAK" ]; then
    echo "FAIL: Backup file $BAK missing."
    exit 1
fi

TARGET_CONTENT=$(cat "$TARGET")
BAK_CONTENT=$(cat "$BAK")

if [ "$TARGET_CONTENT" != "$BAK_CONTENT" ]; then
    echo "FAIL: $TARGET content does not match backup $BAK."
    exit 1
fi

echo "PASS: Configuration restored from backup successfully."
exit 0
