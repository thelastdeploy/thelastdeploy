#!/bin/bash
set -euo pipefail

TARGET="$HOME/service-test/lifecycle_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "^SERVICE_STATUS: active" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'SERVICE_STATUS: active'."
    exit 1
fi

echo "PASS: Service lifecycle summary verified."
exit 0
