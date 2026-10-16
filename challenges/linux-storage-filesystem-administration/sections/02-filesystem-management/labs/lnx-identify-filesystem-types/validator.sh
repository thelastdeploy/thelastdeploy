#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/fs_summary.txt"

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist or is empty."
    exit 1
fi

CONTENT=$(cat "$TARGET")

# Check for simulated blkid format with UUID
if echo "$CONTENT" | grep -q "ext4" && echo "$CONTENT" | grep -q "a1b2c3d4-e5f6-7890-abcd-1234567890ab"; then
    echo "PASS: Filesystem format and UUID identification verified."
    exit 0
fi

# Also accept live blkid output containing valid TYPE and UUID fields
if echo "$CONTENT" | grep -Eq "TYPE=[\"'](ext4|xfs|btrfs|vfat|overlay)[\"']" && echo "$CONTENT" | grep -Eq "UUID="; then
    echo "PASS: Filesystem format and UUID identification verified."
    exit 0
fi

echo "FAIL: $TARGET does not contain valid filesystem format and UUID details."
exit 1
