#!/bin/bash
set -euo pipefail

TARGET="$HOME/env-test/env_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "USER_NAME="; then
    echo "FAIL: $TARGET missing 'USER_NAME=' entry."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "SHELL_PATH="; then
    echo "FAIL: $TARGET missing 'SHELL_PATH=' entry."
    exit 1
fi

echo "PASS: Environment inspection summary verified."
exit 0
