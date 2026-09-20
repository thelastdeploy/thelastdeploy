#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/interactive.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

if ! grep -q "read " "$SCRIPT_PATH"; then
    echo "FAIL: $SCRIPT_PATH must use the 'read' command to prompt for input."
    exit 1
fi

OUTPUT=$(printf "api-server\nproduction\n" | "$SCRIPT_PATH" 2>&1)
EXPECTED="Deploying api-server to production"

if [[ "$OUTPUT" != *"$EXPECTED"* ]]; then
    echo "FAIL: Output should contain '$EXPECTED', got: '$OUTPUT'"
    exit 1
fi

echo "PASS: Interactive script validated successfully."
exit 0
