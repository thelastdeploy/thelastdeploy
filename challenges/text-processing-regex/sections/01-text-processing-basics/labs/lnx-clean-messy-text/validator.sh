#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/clean.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")
EXPECTED="system error report - severity high"

if [ "$CONTENT" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$CONTENT'."
    exit 1
fi

echo "PASS: Text translation cleanly executed."
exit 0
