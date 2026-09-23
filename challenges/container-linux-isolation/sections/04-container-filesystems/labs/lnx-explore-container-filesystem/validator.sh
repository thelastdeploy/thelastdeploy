#!/bin/bash
set -euo pipefail

TARGET="$HOME/container-fs-test/rootfs_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CONTAINER_ROOTFS_EXPLORED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CONTAINER_ROOTFS_EXPLORED'."
    exit 1
fi

echo "PASS: Container filesystem abstraction exploration verified."
exit 0
