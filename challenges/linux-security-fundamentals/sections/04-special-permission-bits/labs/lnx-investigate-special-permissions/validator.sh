#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/suid_files.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "suid_tool"; then
    echo "FAIL: $TARGET missing SUID executable 'suid_tool'."
    exit 1
fi

if echo "$CONTENT" | grep -q "normal_tool"; then
    echo "FAIL: $TARGET contains non-SUID binary 'normal_tool'."
    exit 1
fi

echo "PASS: SUID special permission audit verified."
exit 0
