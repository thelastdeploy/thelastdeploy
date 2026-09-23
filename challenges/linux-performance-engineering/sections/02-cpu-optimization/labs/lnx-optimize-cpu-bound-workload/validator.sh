#!/bin/bash
set -euo pipefail

TARGET="$HOME/cpu-opt-test/cpu_optimization.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CPU_WORKLOAD_OPTIMIZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CPU_WORKLOAD_OPTIMIZED'."
    exit 1
fi

echo "PASS: CPU-bound workload execution optimization verified."
exit 0
