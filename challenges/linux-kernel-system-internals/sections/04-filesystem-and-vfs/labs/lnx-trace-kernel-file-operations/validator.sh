#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/vfs-internals/file_ops.log" ] && grep -q "KERNEL_FILE_OPERATIONS_AND_CACHE_TRACED" "$HOME/vfs-internals/file_ops.log"; then
    echo "PASS: Trace Kernel File Operations verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Kernel File Operations."
    exit 1
fi
