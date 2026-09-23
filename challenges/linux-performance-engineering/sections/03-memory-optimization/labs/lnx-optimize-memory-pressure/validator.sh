#!/bin/bash
set -euo pipefail

TARGET="$HOME/mem-opt-test/mem_tuning.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "MEMORY_SUBSYSTEM_OPTIMIZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'MEMORY_SUBSYSTEM_OPTIMIZED'."
    exit 1
fi

echo "PASS: Memory subsystem tuneables optimization verified."
exit 0
