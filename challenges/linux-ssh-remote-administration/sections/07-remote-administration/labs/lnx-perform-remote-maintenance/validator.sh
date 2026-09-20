#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/ssh-test/maint_runner.sh"
LOG_PATH="$HOME/ssh-test/maint_execution.log"

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
    echo "FAIL: $LOG_PATH was not created by $SCRIPT_PATH."
    exit 1
fi

CONTENT=$(cat "$LOG_PATH")
for HOST in web1 web2 web3; do
    if ! echo "$CONTENT" | grep -q "MAINTENANCE_COMPLETE: $HOST"; then
        echo "FAIL: $LOG_PATH missing entry 'MAINTENANCE_COMPLETE: $HOST'."
        exit 1
    fi
done

echo "PASS: Remote batch maintenance automation verified."
exit 0
