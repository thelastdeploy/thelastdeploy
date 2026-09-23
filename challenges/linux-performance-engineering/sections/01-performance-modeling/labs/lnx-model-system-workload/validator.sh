#!/bin/bash
set -euo pipefail

TARGET="$HOME/perf-eng-test/workload_model.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "WORKLOAD_MODEL_ESTABLISHED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'WORKLOAD_MODEL_ESTABLISHED'."
    exit 1
fi

echo "PASS: Workload profile modeling verified."
exit 0
