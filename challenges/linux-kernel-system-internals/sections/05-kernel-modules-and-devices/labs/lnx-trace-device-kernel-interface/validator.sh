#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/kernel-modules/device_interface.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "DEVICE_MAJOR_MINOR_INTERFACE_TRACED" "$TARGET"; then
    echo "FAIL: Requirement not met for Trace Device Kernel Interface."
    exit 1
fi

echo "PASS: Trace Device Kernel Interface verified successfully."
exit 0
