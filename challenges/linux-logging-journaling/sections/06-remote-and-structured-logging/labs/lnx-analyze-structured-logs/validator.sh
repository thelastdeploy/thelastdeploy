#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/json_errors.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "token expired"; then
    echo "FAIL: $TARGET missing 'token expired' error record."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "connection timeout"; then
    echo "FAIL: $TARGET missing 'connection timeout' error record."
    exit 1
fi

if echo "$CONTENT" | grep -q '"level":"info"'; then
    echo "FAIL: $TARGET contains non-error 'info' level entries."
    exit 1
fi

echo "PASS: Structured JSON log analysis verified."
exit 0
