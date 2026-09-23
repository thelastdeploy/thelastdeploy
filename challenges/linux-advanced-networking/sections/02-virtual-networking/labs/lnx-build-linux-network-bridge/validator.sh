#!/bin/bash
set -euo pipefail

TARGET="$HOME/vnet-test/bridge_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BRIDGE_CREATED: br-test" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BRIDGE_CREATED: br-test'."
    exit 1
fi

echo "PASS: Linux network bridge setup verified."
exit 0
