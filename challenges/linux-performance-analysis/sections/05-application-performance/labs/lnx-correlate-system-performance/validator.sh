#!/bin/bash
set -euo pipefail

TARGET="$HOME/app-perf-test/correlation_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "METRICS_CORRELATED:" "$TARGET"; then
    echo "FAIL: $TARGET missing 'METRICS_CORRELATED:'."
    exit 1
fi

echo "PASS: System performance metrics correlation verified."
exit 0
