#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/storage-admin/storage_plan.conf"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "ENTERPRISE_STORAGE_LAYOUT_PLANNED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'ENTERPRISE_STORAGE_LAYOUT_PLANNED'."
    exit 1
fi

echo "PASS: Plan Server Storage verified successfully."
exit 0
