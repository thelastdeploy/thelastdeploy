#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/service_root_cause.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -qi "Port 5432 already in use"; then
    echo "FAIL: $TARGET does not contain root cause explanation 'Port 5432 already in use'."
    exit 1
fi

echo "PASS: Failed service crash root cause investigation verified."
exit 0
