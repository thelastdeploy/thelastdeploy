#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/complex-failure/cascading_recovery.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "CASCADING_MULTI_LAYER_FAILURE_RESOLVED" "$TARGET"; then
    echo "PASS: Correlate Multi-Layer System Failure verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Correlate Multi-Layer System Failure."
    exit 1
fi
