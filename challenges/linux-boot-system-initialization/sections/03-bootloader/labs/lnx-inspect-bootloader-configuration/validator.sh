#!/bin/bash
set -euo pipefail

TARGET="$HOME/grub-test/grub_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "GRUB_CONFIG_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'GRUB_CONFIG_INSPECTED'."
    exit 1
fi

echo "PASS: Bootloader configuration inspection verified."
exit 0
