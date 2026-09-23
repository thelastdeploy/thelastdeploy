#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/proc-sched/state_trace.log" ] && grep -q "PROCESS_STATE_MACHINE_TRANSITIONS_TRACED" "$HOME/proc-sched/state_trace.log"; then
    echo "PASS: Trace Process State Changes verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Process State Changes."
    exit 1
fi
