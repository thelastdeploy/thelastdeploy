#!/bin/bash
set -euo pipefail

SCRIPT="$HOME/trap-test/trap_demo.sh"
LOG="$HOME/trap-test/cleanup_log.txt"
LOCK="$HOME/trap-test/work.lock"

if [ ! -f "$SCRIPT" ] || [ ! -x "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist or is not executable."
    exit 1
fi

if [ -f "$LOCK" ]; then
    echo "FAIL: Lock file $LOCK was not cleaned up on script termination."
    exit 1
fi

if [ ! -f "$LOG" ] || ! grep -q "Cleaned up lock file" "$LOG"; then
    echo "FAIL: $LOG does not contain expected trap execution message."
    exit 1
fi

echo "PASS: Script signal trap handling verified."
exit 0
