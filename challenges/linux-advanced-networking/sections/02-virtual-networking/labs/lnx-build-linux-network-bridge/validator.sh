#!/bin/bash
set -euo pipefail

TARGET="$HOME/vnet-test/bridge_summary.txt"

SCRIPT="$HOME/vnet-test/bridge_setup.sh"

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

if ! grep -q "BRIDGE_CREATED: br-test" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BRIDGE_CREATED: br-test'."
    exit 1
fi

echo "PASS: Linux network bridge setup verified."
exit 0
