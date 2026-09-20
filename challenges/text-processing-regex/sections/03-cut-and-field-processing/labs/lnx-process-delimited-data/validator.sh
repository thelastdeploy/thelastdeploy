#!/bin/bash
set -euo pipefail

TARGET="$HOME/text-test/user_uids.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(cut -d ',' -f 1,3 "$HOME/text-test/users.csv")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: Delimited cut processing verified."
exit 0
