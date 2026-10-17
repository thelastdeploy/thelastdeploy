#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/kernel-interface/kernel_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "KERNEL_VERSION_AND_CMDLINE_INSPECTED" "$TARGET"; then
    echo "FAIL: Requirement not met for Explore Kernel Information."
    exit 1
fi

echo "PASS: Explore Kernel Information verified successfully."
exit 0
