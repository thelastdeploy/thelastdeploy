#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/resource-crisis/high_load_analysis.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "UNPLAINED_HIGH_LOAD_DIAGNOSED_AND_RESOLVED" "$TARGET" || grep -q "UNEXPLAINED_HIGH_LOAD_DIAGNOSED_AND_RESOLVED" "$TARGET"; then
    echo "PASS: Investigate Unexplained High Load Average verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Unexplained High Load Average."
    exit 1
fi
