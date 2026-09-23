#!/bin/bash
set -euo pipefail

TARGET="$HOME/kernel-test/initramfs_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "INITRAMFS_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'INITRAMFS_INSPECTED'."
    exit 1
fi

echo "PASS: initramfs image investigation verified."
exit 0
