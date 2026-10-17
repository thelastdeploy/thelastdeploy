#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-admin/net_storage_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "NETWORK_AND_STORAGE_ORCHESTRATION_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'NETWORK_AND_STORAGE_ORCHESTRATION_MASTERED'."
    exit 1
fi

echo "PASS: Master Network and Storage verified successfully."
exit 0
