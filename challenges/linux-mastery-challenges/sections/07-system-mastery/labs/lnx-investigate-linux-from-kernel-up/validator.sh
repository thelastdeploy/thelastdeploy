#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-internals/internals_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "KERNEL_AND_SYSTEM_INTERNALS_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'KERNEL_AND_SYSTEM_INTERNALS_MASTERED'."
    exit 1
fi

echo "PASS: Investigate Linux From Kernel Up verified successfully."
exit 0
