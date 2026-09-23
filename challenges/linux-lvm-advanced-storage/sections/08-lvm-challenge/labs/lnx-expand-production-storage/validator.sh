#!/bin/bash
set -euo pipefail

TARGET="$HOME/lvm-capstone/expansion.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PRODUCTION_EXPANSION_COMPLETE" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_EXPANSION_COMPLETE'."
    exit 1
fi

echo "PASS: Production volume expansion capstone verified."
exit 0
