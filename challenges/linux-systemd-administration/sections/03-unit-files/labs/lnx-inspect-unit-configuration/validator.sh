#!/bin/bash
set -euo pipefail

TARGET="$HOME/unit-test/directives.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "EXEC_START_FOUND" "$TARGET"; then
    echo "FAIL: $TARGET missing 'EXEC_START_FOUND'."
    exit 1
fi

echo "PASS: Unit configuration inspection verified."
exit 0
