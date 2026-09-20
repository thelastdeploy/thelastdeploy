#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/top_error_ips.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(grep ' 500 ' "$HOME/text-test/audit.log" | cut -d ' ' -f 1 | sort | uniq -c | sort -nr)
ACTUAL=$(cat "$TARGET")

NORM_EXPECTED=$(echo "$EXPECTED" | awk '{$1=$1; print}')
NORM_ACTUAL=$(echo "$ACTUAL" | awk '{$1=$1; print}')

if [ "$NORM_ACTUAL" != "$NORM_EXPECTED" ]; then
    echo "FAIL: Expected '$NORM_EXPECTED', got '$NORM_ACTUAL'."
    exit 1
fi

echo "PASS: Multi-stage pipeline processing verified."
exit 0
