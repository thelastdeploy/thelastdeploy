#!/bin/bash
set -euo pipefail

TARGET="$HOME/log-test/error_summary.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(grep -E "ERROR|FATAL" "$HOME/log-test/app.log")
ACTUAL=$(cat "$TARGET")

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: Error and fatal log extraction verified."
exit 0
