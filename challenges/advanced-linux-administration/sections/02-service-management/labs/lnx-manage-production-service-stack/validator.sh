#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/service-stack/production_stack.status"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PRODUCTION_SERVICE_STACK_OPERATIONAL" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_SERVICE_STACK_OPERATIONAL'."
    exit 1
fi

echo "PASS: Manage Production Service Stack verified successfully."
exit 0
