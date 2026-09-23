#!/bin/bash
set -euo pipefail

TARGET="$HOME/mig-test/pvmove_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PVMOVE_MIGRATION_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PVMOVE_MIGRATION_VERIFIED'."
    exit 1
fi

echo "PASS: LVM storage migration verified."
exit 0
