#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/proc-sched/state_trace.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PROCESS_STATE_MACHINE_TRANSITIONS_TRACED" "$TARGET"; then
    echo "FAIL: Requirement not met for Trace Process State Changes."
    exit 1
fi

echo "PASS: Trace Process State Changes verified successfully."
exit 0
