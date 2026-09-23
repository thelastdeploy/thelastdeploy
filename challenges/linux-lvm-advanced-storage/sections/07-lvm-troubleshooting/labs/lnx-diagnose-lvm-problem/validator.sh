#!/bin/bash
set -euo pipefail

TARGET="$HOME/lvm-diag/diag_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "LVM_DIAGNOSTICS_COMPLETED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LVM_DIAGNOSTICS_COMPLETED'."
    exit 1
fi

echo "PASS: LVM diagnostics verified."
exit 0
