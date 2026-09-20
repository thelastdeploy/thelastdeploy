#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/eval_result.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "SCENARIO_1: DENIED"; then
    echo "FAIL: $TARGET missing 'SCENARIO_1: DENIED'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "SCENARIO_2: ALLOWED"; then
    echo "FAIL: $TARGET missing 'SCENARIO_2: ALLOWED'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "SCENARIO_3: ALLOWED"; then
    echo "FAIL: $TARGET missing 'SCENARIO_3: ALLOWED'."
    exit 1
fi

echo "PASS: Permission evaluation scenario logic verified."
exit 0
