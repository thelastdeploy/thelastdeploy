#!/bin/bash
set -euo pipefail

TARGET="$HOME/mem-perf-test/swap_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SWAP_ACTIVITY_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SWAP_ACTIVITY_INVESTIGATED'."
    exit 1
fi

echo "PASS: Swap activity and page fault investigation verified."
exit 0
