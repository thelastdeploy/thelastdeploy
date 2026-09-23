#!/bin/bash
set -euo pipefail

TARGET="$HOME/tc-test/tc_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "TC_QDISC_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'TC_QDISC_INSPECTED'."
    exit 1
fi

echo "PASS: Traffic control inspection verified."
exit 0
