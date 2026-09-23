#!/bin/bash
set -euo pipefail

TARGET="$HOME/perf-test/bottleneck.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BOTTLENECK_IDENTIFIED:" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BOTTLENECK_IDENTIFIED:' entry."
    exit 1
fi

echo "PASS: System resource bottleneck identification verified."
exit 0
