#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/recent_access.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

LINE_COUNT=$(wc -l < "$TARGET" | tr -d ' ')
if [ "$LINE_COUNT" -ne 10 ]; then
    echo "FAIL: Expected 10 lines in $TARGET, found $LINE_COUNT."
    exit 1
fi

EXPECTED=$(tail -n 10 "$HOME/log-test/app_logs/web_access.log")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: $TARGET content does not match tail output."
    exit 1
fi

echo "PASS: Application log inspection verified."
exit 0
