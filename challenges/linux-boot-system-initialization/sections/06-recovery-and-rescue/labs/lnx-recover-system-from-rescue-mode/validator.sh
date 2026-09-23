#!/bin/bash
set -euo pipefail

TARGET="$HOME/rescue-test/rescue_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "RESCUE_MODE_RECOVERY_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'RESCUE_MODE_RECOVERY_VERIFIED'."
    exit 1
fi

echo "PASS: System recovery from rescue mode verified."
exit 0
