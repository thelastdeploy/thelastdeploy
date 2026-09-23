#!/bin/bash
set -euo pipefail

TARGET="$HOME/target-test/target_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "^DEFAULT_TARGET: " "$TARGET"; then
    echo "FAIL: $TARGET missing 'DEFAULT_TARGET: ' entry."
    exit 1
fi

echo "PASS: System target investigation verified."
exit 0
