#!/bin/bash
set -euo pipefail

TARGET="$HOME/env-test/active_settings.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if echo "$CONTENT" | grep -q "^#"; then
    echo "FAIL: $TARGET contains comment lines."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "PORT=8080"; then
    echo "FAIL: $TARGET missing active setting 'PORT=8080'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "WORKERS=4"; then
    echo "FAIL: $TARGET missing active setting 'WORKERS=4'."
    exit 1
fi

echo "PASS: Active configuration settings extraction verified."
exit 0
