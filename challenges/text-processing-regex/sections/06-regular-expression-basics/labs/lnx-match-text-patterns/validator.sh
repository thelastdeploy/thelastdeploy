#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/errors.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(grep '^\\[ERROR\\]' "$HOME/text-test/system.log" || grep '^\[ERROR\]' "$HOME/text-test/system.log")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: Anchored pattern matching verified."
exit 0
