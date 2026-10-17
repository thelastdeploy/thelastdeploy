#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/kernel-modules/module_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "KERNEL_MODULES_AND_PARAMETERS_ANALYZED" "$TARGET"; then
    echo "FAIL: Requirement not met for Investigate Kernel Modules."
    exit 1
fi

echo "PASS: Investigate Kernel Modules verified successfully."
exit 0
