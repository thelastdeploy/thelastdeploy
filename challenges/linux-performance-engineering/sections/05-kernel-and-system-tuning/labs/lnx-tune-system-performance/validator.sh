#!/bin/bash
set -euo pipefail

TARGET="$HOME/kernel-opt-test/system_tuned.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_PERFORMANCE_TUNED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_PERFORMANCE_TUNED'."
    exit 1
fi

echo "PASS: System performance parameters tuning verified."
exit 0
