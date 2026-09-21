#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/fs_health.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -qi "clean"; then
    echo "FAIL: $TARGET missing filesystem state 'clean'."
    exit 1
fi

echo "PASS: Filesystem health metadata inspection verified."
exit 0
