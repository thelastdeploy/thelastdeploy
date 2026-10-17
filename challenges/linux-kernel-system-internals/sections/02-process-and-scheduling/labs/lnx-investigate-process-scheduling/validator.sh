#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/proc-sched/sched_investigation.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PROCESS_SCHEDULER_VRUNTIME_EXAMINED" "$TARGET"; then
    echo "FAIL: Requirement not met for Investigate Process Scheduling."
    exit 1
fi

echo "PASS: Investigate Process Scheduling verified successfully."
exit 0
