#!/bin/bash
set -euo pipefail

TARGET="$HOME/cpu-perf-test/offending_pid.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "OFFENDING_CPU_PROCESS_IDENTIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'OFFENDING_CPU_PROCESS_IDENTIFIED'."
    exit 1
fi

echo "PASS: CPU-intensive workload process tracing verified."
exit 0
