#!/bin/bash
set -euo pipefail

TARGET="$HOME/bench-test/benchmark_comparison.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BENCHMARK_VALIDATION_COMPLETE: IMPROVEMENT_PROVED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BENCHMARK_VALIDATION_COMPLETE: IMPROVEMENT_PROVED'."
    exit 1
fi

echo "PASS: Benchmark and validation of system tuning changes verified."
exit 0
