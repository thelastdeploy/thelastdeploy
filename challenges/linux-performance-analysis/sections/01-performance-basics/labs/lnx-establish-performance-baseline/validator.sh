#!/bin/bash
set -euo pipefail

TARGET="$HOME/perf-test/baseline.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PERFORMANCE_BASELINE_ESTABLISHED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PERFORMANCE_BASELINE_ESTABLISHED'."
    exit 1
fi

echo "PASS: System performance baseline established."
exit 0
