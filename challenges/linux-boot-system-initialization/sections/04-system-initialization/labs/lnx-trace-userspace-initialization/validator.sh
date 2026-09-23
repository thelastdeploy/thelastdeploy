#!/bin/bash
set -euo pipefail

TARGET="$HOME/sys-init-test/boot_time.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BOOT_TIME_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BOOT_TIME_ANALYZED'."
    exit 1
fi

echo "PASS: Userspace initialization sequence trace verified."
exit 0
