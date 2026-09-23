#!/bin/bash
set -euo pipefail

TARGET="$HOME/ir-test/volatile_state.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "VOLATILE_SYSTEM_STATE_PRESERVED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'VOLATILE_SYSTEM_STATE_PRESERVED'."
    exit 1
fi

echo "PASS: Volatile system state preservation verified."
exit 0
