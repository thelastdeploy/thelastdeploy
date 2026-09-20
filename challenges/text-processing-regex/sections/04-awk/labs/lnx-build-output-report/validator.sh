#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/report_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(awk '{ sum += ($2 * $3) } END { print "TOTAL_REVENUE:", sum }' "$HOME/text-test/sales.txt")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: AWK aggregation report summary verified."
exit 0
