#!/bin/bash
set -euo pipefail

TARGET="$HOME/cpu-opt-test/contention_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CPU_CONTENTION_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CPU_CONTENTION_ANALYZED'."
    exit 1
fi

echo "PASS: CPU scheduler contention analysis verified."
exit 0
