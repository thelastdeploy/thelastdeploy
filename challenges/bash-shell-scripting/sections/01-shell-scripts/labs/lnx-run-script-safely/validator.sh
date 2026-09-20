#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/safe.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

if ! grep -Eq "set -(euo pipefail|eu)" "$SCRIPT_PATH"; then
    echo "FAIL: $SCRIPT_PATH must include strict flags 'set -eu' or 'set -euo pipefail'."
    exit 1
fi

OUTPUT=$("$SCRIPT_PATH" 2>&1)
if [[ "$OUTPUT" != *"Safe Execution"* ]]; then
    echo "FAIL: Script output should contain 'Safe Execution'. Got: '$OUTPUT'"
    exit 1
fi

echo "PASS: Script configured with strict execution mode."
exit 0
