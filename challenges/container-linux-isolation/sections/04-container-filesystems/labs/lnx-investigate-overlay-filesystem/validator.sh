#!/bin/bash
set -euo pipefail

TARGET="$HOME/container-fs-test/overlay_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "OVERLAYFS_LAYERS_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'OVERLAYFS_LAYERS_INVESTIGATED'."
    exit 1
fi

echo "PASS: OverlayFS storage layer investigation verified."
exit 0
