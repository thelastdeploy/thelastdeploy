#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/vfs-internals/vfs_structures.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "VFS_FILE_DESCRIPTORS_AND_INODES_INVESTIGATED" "$TARGET"; then
    echo "FAIL: Requirement not met for Investigate VFS Abstraction Behavior."
    exit 1
fi

echo "PASS: Investigate VFS Abstraction Behavior verified successfully."
exit 0
