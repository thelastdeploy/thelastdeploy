#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-perf/perf_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "LINUX_WORKLOAD_PERFORMANCE_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LINUX_WORKLOAD_PERFORMANCE_MASTERED'."
    exit 1
fi

echo "PASS: Optimize Linux Workload verified successfully."
exit 0
