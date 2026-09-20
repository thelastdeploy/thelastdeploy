#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/env-test/run_app.sh"
LOG_PATH="$HOME/env-test/app_runtime.log"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

"$SCRIPT_PATH"

if [ ! -f "$LOG_PATH" ]; then
    echo "FAIL: $LOG_PATH was not created."
    exit 1
fi

CONTENT=$(cat "$LOG_PATH")

if ! echo "$CONTENT" | grep -q "PORT=5000"; then
    echo "FAIL: $LOG_PATH missing 'PORT=5000'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "LOG_LEVEL=debug"; then
    echo "FAIL: $LOG_PATH missing 'LOG_LEVEL=debug'."
    exit 1
fi

echo "PASS: Environment-driven application loader script verified."
exit 0
