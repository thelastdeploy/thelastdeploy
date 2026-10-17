#!/bin/bash
set -euo pipefail

TARGET="$HOME/lvm-capstone/expansion.log"

SCRIPT="$HOME/lvm-capstone/expand_app.sh"

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

if ! grep -q "PRODUCTION_EXPANSION_COMPLETE" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_EXPANSION_COMPLETE'."
    exit 1
fi

echo "PASS: Production volume expansion capstone verified."
exit 0
