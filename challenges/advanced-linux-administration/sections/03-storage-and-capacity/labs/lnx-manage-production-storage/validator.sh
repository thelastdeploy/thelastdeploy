#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/storage-admin/lvm_expansion.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "LIVE_PRODUCTION_STORAGE_EXPANDED_SUCCESSFULLY" "$TARGET"; then
    echo "FAIL: $TARGET missing 'LIVE_PRODUCTION_STORAGE_EXPANDED_SUCCESSFULLY'."
    exit 1
fi

echo "PASS: Manage Production Storage verified successfully."
exit 0
