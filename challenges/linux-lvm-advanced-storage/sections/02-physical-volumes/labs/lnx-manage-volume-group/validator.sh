#!/bin/bash
set -euo pipefail

TARGET="$HOME/pv-test/vg_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "VG_MANAGEMENT_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'VG_MANAGEMENT_VERIFIED'."
    exit 1
fi

echo "PASS: Volume group management verified."
exit 0
