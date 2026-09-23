#!/bin/bash
set -euo pipefail

TARGET="$HOME/kernel-opt-test/sysctl_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "KERNEL_TUNEABLES_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'KERNEL_TUNEABLES_ANALYZED'."
    exit 1
fi

echo "PASS: Kernel subsystem tuneables analysis verified."
exit 0
