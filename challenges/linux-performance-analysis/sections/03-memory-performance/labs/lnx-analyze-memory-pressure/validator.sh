#!/bin/bash
set -euo pipefail

TARGET="$HOME/mem-perf-test/mem_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "MEMORY_PRESSURE_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'MEMORY_PRESSURE_ANALYZED'."
    exit 1
fi

echo "PASS: Memory pressure and page cache analysis verified."
exit 0
