#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/kernel-failure/kernel_investigation.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "KERNEL_LEVEL_FAILURE_ROOT_CAUSE_DIAGNOSED" "$TARGET"; then
    echo "FAIL: Requirement not met for Investigate Kernel-Level Failure."
    exit 1
fi

echo "PASS: Investigate Kernel-Level Failure verified successfully."
exit 0
