#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/resource-crisis/high_load_analysis.log" ] && grep -q "UNEXPLAINED_HIGH_LOAD_DIAGNOSED_AND_RESOLVED" "$HOME/resource-crisis/high_load_analysis.log"; then
    echo "PASS: Investigate Unexplained High Load Average verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Unexplained High Load Average."
    exit 1
fi
