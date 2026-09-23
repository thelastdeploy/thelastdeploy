#!/bin/bash
set -euo pipefail

TARGET="$HOME/boot-fail-test/diag_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BOOT_FAIL_REASON: invalid_fstab_uuid" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BOOT_FAIL_REASON: invalid_fstab_uuid'."
    exit 1
fi

echo "PASS: Failed boot configuration investigation verified."
exit 0
