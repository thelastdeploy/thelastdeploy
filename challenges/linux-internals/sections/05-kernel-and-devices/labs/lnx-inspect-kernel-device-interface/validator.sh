#!/bin/bash
set -euo pipefail

TARGET="$HOME/sysfs-test/interfaces.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "KERNEL_DEVICE_INTERFACES_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'KERNEL_DEVICE_INTERFACES_INSPECTED'."
    exit 1
fi

echo "PASS: Kernel device interfaces inspection verified."
exit 0
