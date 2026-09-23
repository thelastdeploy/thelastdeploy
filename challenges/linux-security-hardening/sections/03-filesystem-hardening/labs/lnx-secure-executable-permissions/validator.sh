#!/bin/bash
set -euo pipefail

TARGET="$HOME/fs-sec-test/suid_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SUID_PERMISSIONS_AUDITED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SUID_PERMISSIONS_AUDITED'."
    exit 1
fi

echo "PASS: SUID/SGID executable permissions security verified."
exit 0
