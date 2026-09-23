#!/bin/bash
set -euo pipefail

TARGET="$HOME/syscall-test/syscall_basics.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_CALL_BOUNDARY_OBSERVED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_CALL_BOUNDARY_OBSERVED'."
    exit 1
fi

echo "PASS: System call boundary observation verified."
exit 0
