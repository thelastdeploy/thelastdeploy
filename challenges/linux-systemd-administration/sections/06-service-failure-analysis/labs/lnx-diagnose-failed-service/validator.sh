#!/bin/bash
set -euo pipefail

TARGET="$HOME/fail-test/diag_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "REASON: missing_executable" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'REASON: missing_executable'."
    exit 1
fi

echo "PASS: Failed service diagnosis verified."
exit 0
