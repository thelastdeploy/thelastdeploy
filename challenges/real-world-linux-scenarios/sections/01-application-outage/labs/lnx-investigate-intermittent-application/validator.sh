#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/app-outage/intermittent_root_cause.txt"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "INTERMITTENT_FAILURE_ROOT_CAUSE_DIAGNOSED" "$TARGET"; then
    echo "PASS: Investigate Intermittent Application Failures verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Intermittent Application Failures."
    exit 1
fi
