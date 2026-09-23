#!/bin/bash
set -euo pipefail

TARGET="$HOME/svc-outage-test/stack_recovery.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "DEPENDENT_STACK_RECOVERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'DEPENDENT_STACK_RECOVERED'."
    exit 1
fi

echo "PASS: Dependent service stack recovery verified."
exit 0
