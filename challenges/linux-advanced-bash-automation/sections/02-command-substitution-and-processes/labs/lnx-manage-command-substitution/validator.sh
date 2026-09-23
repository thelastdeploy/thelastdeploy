#!/bin/bash
set -euo pipefail

TARGET="$HOME/proc-sub-test/diff_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "postgresql" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'postgresql'."
    exit 1
fi

echo "PASS: Process substitution diff report verified."
exit 0
