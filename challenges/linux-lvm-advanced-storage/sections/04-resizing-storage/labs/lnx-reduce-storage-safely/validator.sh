#!/bin/bash
set -euo pipefail

TARGET="$HOME/resize-test/safe_reduce_steps.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "1. umount" "$TARGET" || ! grep -q "3. resize2fs" "$TARGET" || ! grep -q "4. lvreduce" "$TARGET"; then
    echo "FAIL: $TARGET missing required safe reduction steps sequence."
    exit 1
fi

echo "PASS: Safe storage reduction sequence verified."
exit 0
