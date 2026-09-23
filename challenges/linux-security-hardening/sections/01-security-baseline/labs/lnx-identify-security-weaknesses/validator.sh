#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/weaknesses.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "WEAKNESSES_IDENTIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'WEAKNESSES_IDENTIFIED'."
    exit 1
fi

echo "PASS: System security weaknesses identification verified."
exit 0
