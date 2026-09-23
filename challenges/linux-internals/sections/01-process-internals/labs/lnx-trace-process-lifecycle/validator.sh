#!/bin/bash
set -euo pipefail

TARGET="$HOME/proc-internals-test/lifecycle.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PROCESS_LIFECYCLE_TRACED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PROCESS_LIFECYCLE_TRACED'."
    exit 1
fi

echo "PASS: Process execution lifecycle tracing verified."
exit 0
