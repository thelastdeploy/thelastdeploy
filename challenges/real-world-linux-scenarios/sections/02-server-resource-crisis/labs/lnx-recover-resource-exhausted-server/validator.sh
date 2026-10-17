#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/resource-crisis/oom_recovery.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "RESOURCE_EXHAUSTED_SERVER_RECOVERED" "$TARGET"; then
    echo "PASS: Recover Resource-Exhausted Server verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Resource-Exhausted Server."
    exit 1
fi
