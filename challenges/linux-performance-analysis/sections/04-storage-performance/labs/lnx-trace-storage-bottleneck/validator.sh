#!/bin/bash
set -euo pipefail

TARGET="$HOME/io-perf-test/io_pid.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "OFFENDING_IO_PROCESS_TRACED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'OFFENDING_IO_PROCESS_TRACED'."
    exit 1
fi

echo "PASS: Process storage I/O bottleneck tracing verified."
exit 0
