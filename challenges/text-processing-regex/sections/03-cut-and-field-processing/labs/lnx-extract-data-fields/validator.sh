#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/timestamps.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(cut -c 1-10 "$HOME/text-test/fixed_data.txt")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: Cut character extraction verified."
exit 0
