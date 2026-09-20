#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/vars.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

OUTPUT=$("$SCRIPT_PATH" Alice Developer 2>&1)
EXPECTED="User Alice assigned role Developer"

if [[ "$OUTPUT" != *"$EXPECTED"* ]]; then
    echo "FAIL: Expected output to contain '$EXPECTED', got: '$OUTPUT'"
    exit 1
fi

echo "PASS: Script processes positional variables correctly."
exit 0
