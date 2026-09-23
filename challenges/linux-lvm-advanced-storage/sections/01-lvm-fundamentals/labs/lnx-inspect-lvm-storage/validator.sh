#!/bin/bash
set -euo pipefail

TARGET="$HOME/lvm-test/storage_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "LVM_STORAGE_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LVM_STORAGE_INSPECTED'."
    exit 1
fi

echo "PASS: LVM storage allocation inspection verified."
exit 0
