#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/vfs-internals/file_ops.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "KERNEL_FILE_OPERATIONS_AND_CACHE_TRACED" "$TARGET"; then
    echo "FAIL: Requirement not met for Trace Kernel File Operations."
    exit 1
fi

echo "PASS: Trace Kernel File Operations verified successfully."
exit 0
