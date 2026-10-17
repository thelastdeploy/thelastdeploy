#!/bin/bash
set -euo pipefail

TARGET="$HOME/fw-test/filter_summary.txt"

SCRIPT="$HOME/fw-test/filter_rules.sh"

if [ ! -f "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist."
    exit 1
fi

if [ ! -s "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT is empty."
    exit 1
fi

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "FILTERING_RULES_CONFIGURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FILTERING_RULES_CONFIGURED'."
    exit 1
fi

echo "PASS: Network traffic filtering configuration verified."
exit 0
