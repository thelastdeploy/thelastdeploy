#!/bin/bash
set -euo pipefail

TARGET="$HOME/io-opt-test/io_tuning.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "STORAGE_IO_PERFORMANCE_OPTIMIZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'STORAGE_IO_PERFORMANCE_OPTIMIZED'."
    exit 1
fi

echo "PASS: Storage I/O performance optimization verified."
exit 0
