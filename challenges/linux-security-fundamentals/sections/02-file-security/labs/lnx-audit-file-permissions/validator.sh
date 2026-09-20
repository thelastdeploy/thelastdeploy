#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/permission_audit.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "app.conf: 777"; then
    echo "FAIL: $TARGET missing 'app.conf: 777'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "db.conf: 644"; then
    echo "FAIL: $TARGET missing 'db.conf: 644'."
    exit 1
fi

echo "PASS: Permission audit file validated."
exit 0
