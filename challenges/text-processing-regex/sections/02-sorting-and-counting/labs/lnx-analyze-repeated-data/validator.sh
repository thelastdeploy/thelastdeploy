#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/ip_counts.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(sort "$HOME/text-test/access_ips.txt" | uniq -c | sort -nr)
ACTUAL=$(cat "$TARGET")

# Compare normalized outputs (stripping leading whitespace variation)
NORM_EXPECTED=$(echo "$EXPECTED" | awk '{$1=$1; print}')
NORM_ACTUAL=$(echo "$ACTUAL" | awk '{$1=$1; print}')

if [ "$NORM_ACTUAL" != "$NORM_EXPECTED" ]; then
    echo "FAIL: $TARGET content does not match expected sorted count frequency."
    exit 1
fi

echo "PASS: Sort and uniq frequency analysis verified."
exit 0
