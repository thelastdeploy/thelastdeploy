#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-admin/admin_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "SYSTEM_ADMINISTRATION_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_ADMINISTRATION_MASTERED'."
    exit 1
fi

echo "PASS: Master Linux Administration verified successfully."
exit 0
