#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/fs_health.txt"

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist or is empty."
    exit 1
fi

CONTENT=$(cat "$TARGET")

# Check for filesystem state clean or superblock health indicators
if echo "$CONTENT" | grep -qi "clean" || echo "$CONTENT" | grep -Eqi "(Filesystem state|Filesystem volume name|Block count|Inode count)"; then
    echo "PASS: Filesystem health metadata inspection verified."
    exit 0
fi

echo "FAIL: $TARGET does not contain valid filesystem health or superblock metadata."
exit 1
