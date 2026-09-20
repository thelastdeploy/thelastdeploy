#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/high_cpu.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(awk '$3 > 5.0 { print $1, $4 }' "$HOME/text-test/ps_output.txt")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: AWK structured filtering verified."
exit 0
