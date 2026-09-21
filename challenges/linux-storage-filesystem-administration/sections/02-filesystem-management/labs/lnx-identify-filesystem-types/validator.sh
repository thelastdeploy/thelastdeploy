#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/fs_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "ext4"; then
    echo "FAIL: $TARGET missing 'ext4'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "a1b2c3d4-e5f6-7890-abcd-1234567890ab"; then
    echo "FAIL: $TARGET missing UUID 'a1b2c3d4-e5f6-7890-abcd-1234567890ab'."
    exit 1
fi

echo "PASS: Filesystem format and UUID identification verified."
exit 0
