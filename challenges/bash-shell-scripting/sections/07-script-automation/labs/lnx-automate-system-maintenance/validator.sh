#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/script-test/clean_old_logs.sh"
MAINT_LOG="$HOME/script-test/maintenance.log"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

"$SCRIPT_PATH"

if [ -f "$HOME/script-test/active_logs/stale.old" ]; then
    echo "FAIL: $HOME/script-test/active_logs/stale.old was not removed."
    exit 1
fi

if [ ! -f "$HOME/script-test/active_logs/current.log" ]; then
    echo "FAIL: $HOME/script-test/active_logs/current.log was deleted unexpectedly."
    exit 1
fi

if [ ! -f "$MAINT_LOG" ]; then
    echo "FAIL: Maintenance log $MAINT_LOG was not created."
    exit 1
fi

if ! grep -q "CLEANUP_COMPLETE" "$MAINT_LOG"; then
    echo "FAIL: $MAINT_LOG does not contain 'CLEANUP_COMPLETE'."
    exit 1
fi

echo "PASS: System maintenance script validated."
exit 0
