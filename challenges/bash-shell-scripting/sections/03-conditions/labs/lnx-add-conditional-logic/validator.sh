#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/check_num.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

POS_OUT=$("$SCRIPT_PATH" 10 2>&1)
if [[ "$POS_OUT" != *"POSITIVE"* ]]; then
    echo "FAIL: Testing with '10' failed. Expected output to contain 'POSITIVE', got: '$POS_OUT'"
    exit 1
fi

NEG_OUT=$("$SCRIPT_PATH" -5 2>&1)
if [[ "$NEG_OUT" != *"NEGATIVE"* ]]; then
    echo "FAIL: Testing with '-5' failed. Expected output to contain 'NEGATIVE', got: '$NEG_OUT'"
    exit 1
fi

ZERO_OUT=$("$SCRIPT_PATH" 0 2>&1)
if [[ "$ZERO_OUT" != *"ZERO"* ]]; then
    echo "FAIL: Testing with '0' failed. Expected output to contain 'ZERO', got: '$ZERO_OUT'"
    exit 1
fi

echo "PASS: Numerical conditional logic verified."
exit 0
