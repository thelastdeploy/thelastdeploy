#!/bin/bash
set -euo pipefail

TARGET="$HOME/fw-test/filter_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "FILTERING_RULES_CONFIGURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FILTERING_RULES_CONFIGURED'."
    exit 1
fi

echo "PASS: Network traffic filtering configuration verified."
exit 0
