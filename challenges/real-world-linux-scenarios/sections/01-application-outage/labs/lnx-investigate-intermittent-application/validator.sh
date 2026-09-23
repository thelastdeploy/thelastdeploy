#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/app-outage/intermittent_root_cause.txt" ] && grep -q "INTERMITTENT_FAILURE_ROOT_CAUSE_DIAGNOSED" "$HOME/app-outage/intermittent_root_cause.txt"; then
    echo "PASS: Investigate Intermittent Application Failures verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Intermittent Application Failures."
    exit 1
fi
