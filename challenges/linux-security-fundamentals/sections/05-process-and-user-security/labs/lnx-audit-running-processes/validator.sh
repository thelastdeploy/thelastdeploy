#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/www_processes.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

EXPECTED=$(grep "www-data" "$HOME/sec-test/ps_dump.txt" | tr -d '\r' | sed -e 's/[[:space:]]*$//' | sed -e '/^$/d')
ACTUAL=$(tr -d '\r' < "$TARGET" | sed -e 's/[[:space:]]*$//' | sed -e '/^$/d')

if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL: Expected '$EXPECTED', got '$ACTUAL'."
    exit 1
fi

echo "PASS: Process ownership audit verified."
exit 0
