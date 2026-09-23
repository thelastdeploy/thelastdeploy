#!/bin/bash
set -euo pipefail

TARGET="$HOME/perf-challenge/root_cause.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PRODUCTION_PERFORMANCE_DIAGNOSED: ROOT_CAUSE_PROVED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_PERFORMANCE_DIAGNOSED: ROOT_CAUSE_PROVED'."
    exit 1
fi

echo "PASS: Production performance degradation diagnosis capstone verified."
exit 0
