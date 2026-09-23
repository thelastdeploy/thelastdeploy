#!/bin/bash
set -euo pipefail

TARGET="$HOME/io-perf-test/io_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "DISK_IO_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'DISK_IO_ANALYZED'."
    exit 1
fi

echo "PASS: Disk I/O utilization and latency analysis verified."
exit 0
