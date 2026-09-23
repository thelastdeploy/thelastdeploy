#!/bin/bash
set -euo pipefail

TARGET="$HOME/vfs-test/inode_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "INODE_METADATA_EXPLORED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'INODE_METADATA_EXPLORED'."
    exit 1
fi

echo "PASS: Inodes and filesystem metadata exploration verified."
exit 0
