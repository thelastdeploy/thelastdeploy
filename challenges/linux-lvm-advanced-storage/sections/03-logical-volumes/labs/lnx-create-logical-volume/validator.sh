#!/bin/bash
set -euo pipefail

TARGET="$HOME/lv-test/lv_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "LV_CREATE_SYNTAX_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LV_CREATE_SYNTAX_VERIFIED'."
    exit 1
fi

echo "PASS: Logical volume creation syntax verified."
exit 0
