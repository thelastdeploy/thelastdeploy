#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/complex-failure/cascading_recovery.log" ] && grep -q "CASCADING_MULTI_LAYER_FAILURE_RESOLVED" "$HOME/complex-failure/cascading_recovery.log"; then
    echo "PASS: Correlate Multi-Layer System Failure verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Correlate Multi-Layer System Failure."
    exit 1
fi
