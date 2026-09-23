#!/bin/bash
set -euo pipefail

TARGET="$HOME/vfs-test/file_locks.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "FILE_LOCKS_TRACED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FILE_LOCKS_TRACED'."
    exit 1
fi

echo "PASS: File access and open file table tracing verified."
exit 0
