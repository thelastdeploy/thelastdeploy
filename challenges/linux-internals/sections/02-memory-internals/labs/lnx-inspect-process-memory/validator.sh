#!/bin/bash
set -euo pipefail

TARGET="$HOME/mem-internals-test/memory_layout.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PROCESS_MEMORY_LAYOUT_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PROCESS_MEMORY_LAYOUT_INSPECTED'."
    exit 1
fi

echo "PASS: Process memory layout inspection verified."
exit 0
