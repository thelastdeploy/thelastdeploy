#!/bin/bash
set -euo pipefail

TARGET="$HOME/perf-capstone/optimization_validation.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PRODUCTION_WORKLOAD_OPTIMIZED_AND_VALIDATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_WORKLOAD_OPTIMIZED_AND_VALIDATED'."
    exit 1
fi

echo "PASS: Production workload optimization capstone verified."
exit 0
