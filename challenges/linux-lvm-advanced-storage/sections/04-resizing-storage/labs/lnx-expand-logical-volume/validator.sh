#!/bin/bash
set -euo pipefail

TARGET="$HOME/resize-test/expand_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "LV_EXPAND_SYNTAX_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LV_EXPAND_SYNTAX_VERIFIED'."
    exit 1
fi

echo "PASS: Logical volume expansion verified."
exit 0
