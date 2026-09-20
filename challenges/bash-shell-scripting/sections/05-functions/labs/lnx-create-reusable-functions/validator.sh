#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/log_helper.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

# Source script or run test execution
OUTPUT=$(bash -c "source '$SCRIPT_PATH' && log_message 'INFO' 'Database connected'" 2>&1 || true)

if [[ "$OUTPUT" != *"[INFO] Database connected"* ]]; then
    echo "FAIL: Function 'log_message' produced: '$OUTPUT', expected '[INFO] Database connected'."
    exit 1
fi

echo "PASS: Function 'log_message' verified."
exit 0
