#!/bin/bash
set -euo pipefail

TARGET="$HOME/kernel-test/cmdline_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "KERNEL_CMDLINE_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'KERNEL_CMDLINE_INSPECTED'."
    exit 1
fi

echo "PASS: Running kernel inspection verified."
exit 0
