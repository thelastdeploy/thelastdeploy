#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/block_devices.txt"

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist or is empty."
    exit 1
fi

CONTENT=$(cat "$TARGET")

# Check for simulated disk topology with sda and sdb
if echo "$CONTENT" | grep -q "sda" && echo "$CONTENT" | grep -q "sdb"; then
    echo "PASS: Block storage device identification verified."
    exit 0
fi

# Also accept valid live lsblk output containing block device records
if echo "$CONTENT" | grep -Eq "(NAME|TYPE|disk|part)" && echo "$CONTENT" | grep -Eq "(nvme|vda|sda|loop|zram)"; then
    echo "PASS: Block storage device identification verified."
    exit 0
fi

echo "FAIL: $TARGET does not contain valid block device topology."
exit 1
