#!/bin/bash
set -euo pipefail

TARGET="$HOME/io-opt-test/io_profile.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "STORAGE_IO_WORKLOAD_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'STORAGE_IO_WORKLOAD_ANALYZED'."
    exit 1
fi

echo "PASS: Storage I/O workload patterns analysis verified."
exit 0
