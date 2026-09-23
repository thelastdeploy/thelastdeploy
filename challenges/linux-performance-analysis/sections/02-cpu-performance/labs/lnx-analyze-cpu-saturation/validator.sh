#!/bin/bash
set -euo pipefail

TARGET="$HOME/cpu-perf-test/cpu_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CPU_SATURATION_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CPU_SATURATION_ANALYZED'."
    exit 1
fi

echo "PASS: CPU saturation and run queue analysis verified."
exit 0
