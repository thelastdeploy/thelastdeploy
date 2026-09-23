#!/bin/bash
set -euo pipefail

TARGET="$HOME/grub-test/kernel_flags.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "systemd.unit=multi-user.target" "$TARGET"; then
    echo "FAIL: $TARGET missing 'systemd.unit=multi-user.target'."
    exit 1
fi

echo "PASS: Kernel boot parameter management verified."
exit 0
