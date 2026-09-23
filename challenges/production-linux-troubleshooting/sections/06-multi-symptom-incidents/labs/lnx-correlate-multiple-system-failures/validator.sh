#!/bin/bash
set -euo pipefail

TARGET="$HOME/multi-inc-test/correlation_matrix.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "FAILURES_CORRELATED: PRIMARY_CAUSE_ISOLATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FAILURES_CORRELATED: PRIMARY_CAUSE_ISOLATED'."
    exit 1
fi

echo "PASS: Multiple concurrent system failures correlation verified."
exit 0
