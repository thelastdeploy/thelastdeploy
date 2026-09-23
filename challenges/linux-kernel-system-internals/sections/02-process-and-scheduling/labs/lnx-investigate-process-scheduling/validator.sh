#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/proc-sched/sched_investigation.log" ] && grep -q "PROCESS_SCHEDULER_VRUNTIME_EXAMINED" "$HOME/proc-sched/sched_investigation.log"; then
    echo "PASS: Investigate Process Scheduling verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Process Scheduling."
    exit 1
fi
