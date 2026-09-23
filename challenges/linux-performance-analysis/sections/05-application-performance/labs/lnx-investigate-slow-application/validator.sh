#!/bin/bash
set -euo pipefail

TARGET="$HOME/app-perf-test/app_latency.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "APPLICATION_LATENCY_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'APPLICATION_LATENCY_INVESTIGATED'."
    exit 1
fi

echo "PASS: Slow application response investigation verified."
exit 0
