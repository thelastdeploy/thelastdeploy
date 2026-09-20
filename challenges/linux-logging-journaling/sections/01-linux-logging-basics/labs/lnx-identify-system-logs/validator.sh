#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/auth_file.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "auth.log"; then
    echo "FAIL: $TARGET does not contain 'auth.log'."
    exit 1
fi

echo "PASS: Authentication log file identification verified."
exit 0
