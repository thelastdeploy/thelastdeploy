#!/bin/bash
set -euo pipefail

TARGET="$HOME/syscall-test/strace_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "STRACE_SUMMARY_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'STRACE_SUMMARY_VERIFIED'."
    exit 1
fi

echo "PASS: Application system call tracing verified."
exit 0
