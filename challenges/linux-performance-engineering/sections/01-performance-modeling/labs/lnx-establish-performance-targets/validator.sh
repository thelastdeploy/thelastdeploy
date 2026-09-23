#!/bin/bash
set -euo pipefail

TARGET="$HOME/perf-eng-test/sla_targets.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PERFORMANCE_SLA_TARGETS_DEFINED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PERFORMANCE_SLA_TARGETS_DEFINED'."
    exit 1
fi

echo "PASS: SLA and performance targets establishment verified."
exit 0
