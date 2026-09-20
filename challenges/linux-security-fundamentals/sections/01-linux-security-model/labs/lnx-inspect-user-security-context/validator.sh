#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/user_context.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "USER="; then
    echo "FAIL: $TARGET missing 'USER=' entry."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "UID="; then
    echo "FAIL: $TARGET missing 'UID=' entry."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "GROUPS="; then
    echo "FAIL: $TARGET missing 'GROUPS=' entry."
    exit 1
fi

echo "PASS: Security context inspection verified."
exit 0
