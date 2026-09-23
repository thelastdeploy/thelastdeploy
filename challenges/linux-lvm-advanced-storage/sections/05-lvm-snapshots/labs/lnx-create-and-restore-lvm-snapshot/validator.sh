#!/bin/bash
set -euo pipefail

TARGET="$HOME/snap-test/snap_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "LVM_SNAPSHOT_PROCEDURE_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LVM_SNAPSHOT_PROCEDURE_VERIFIED'."
    exit 1
fi

echo "PASS: LVM snapshot procedure verified."
exit 0
