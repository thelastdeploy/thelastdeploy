#!/bin/bash
set -euo pipefail

TARGET="$HOME/boot-test/boot_files.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BOOT_COMPONENTS_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BOOT_COMPONENTS_INSPECTED'."
    exit 1
fi

echo "PASS: Core boot components identification verified."
exit 0
