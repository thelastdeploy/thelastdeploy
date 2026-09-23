#!/bin/bash
set -euo pipefail

TARGET="$HOME/trace-test/system_trace.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_BEHAVIOR_TRACED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_BEHAVIOR_TRACED'."
    exit 1
fi

echo "PASS: System execution behavior tracing verified."
exit 0
