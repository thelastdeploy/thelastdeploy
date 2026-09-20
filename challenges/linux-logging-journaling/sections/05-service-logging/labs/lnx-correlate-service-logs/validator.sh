#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/failing_unit.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "payment-processor.service"; then
    echo "FAIL: $TARGET does not contain 'payment-processor.service'."
    exit 1
fi

echo "PASS: Service correlation unit identification verified."
exit 0
