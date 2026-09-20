#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/archived_fault.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "CRITICAL_DATABASE_FAIL"; then
    echo "FAIL: $TARGET does not contain 'CRITICAL_DATABASE_FAIL'."
    exit 1
fi

echo "PASS: Compressed log archive investigation verified."
exit 0
