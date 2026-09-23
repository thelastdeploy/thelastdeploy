#!/bin/bash
set -euo pipefail

TARGET="$HOME/lv-test/mount_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "LV_FILESYSTEM_CONFIGURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LV_FILESYSTEM_CONFIGURED'."
    exit 1
fi

echo "PASS: Logical volume filesystem configuration verified."
exit 0
