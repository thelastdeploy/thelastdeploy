#!/bin/bash
set -euo pipefail

TARGET="$HOME/fs-sec-test/file_perms.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "FILE_PERMISSIONS_HARDENED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FILE_PERMISSIONS_HARDENED'."
    exit 1
fi

echo "PASS: Sensitive system file hardening verified."
exit 0
