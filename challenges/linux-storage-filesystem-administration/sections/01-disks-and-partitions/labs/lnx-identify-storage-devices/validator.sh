#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/block_devices.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "sda"; then
    echo "FAIL: $TARGET missing 'sda'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "sdb"; then
    echo "FAIL: $TARGET missing 'sdb'."
    exit 1
fi

echo "PASS: Block storage device identification verified."
exit 0
