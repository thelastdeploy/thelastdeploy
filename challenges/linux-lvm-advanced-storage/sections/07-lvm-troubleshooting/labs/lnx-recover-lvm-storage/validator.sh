#!/bin/bash
set -euo pipefail

TARGET="$HOME/lvm-diag/recovery_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "VGCFGRESTORE_RECOVERY_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'VGCFGRESTORE_RECOVERY_VERIFIED'."
    exit 1
fi

echo "PASS: LVM metadata recovery verified."
exit 0
