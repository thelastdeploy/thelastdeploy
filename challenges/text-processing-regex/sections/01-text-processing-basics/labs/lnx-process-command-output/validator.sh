#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/first_five.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

LINE_COUNT=$(wc -l < "$TARGET" | tr -d ' ')
if [ "$LINE_COUNT" -ne 5 ]; then
    echo "FAIL: Expected exactly 5 lines in $TARGET, found $LINE_COUNT."
    exit 1
fi

EXPECTED=$(head -n 5 "$HOME/text-test/raw_logs.txt")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Content of $TARGET does not match the first 5 lines of raw_logs.txt."
    exit 1
fi

echo "PASS: Head output redirection validated successfully."
exit 0
