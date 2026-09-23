#!/bin/bash
set -euo pipefail

TARGET="$HOME/mem-opt-test/mem_behavior.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "MEMORY_BEHAVIOR_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'MEMORY_BEHAVIOR_ANALYZED'."
    exit 1
fi

echo "PASS: Kernel memory allocator behavior analysis verified."
exit 0
