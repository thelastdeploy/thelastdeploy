#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-sec/security_mastery.conf"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PRODUCTION_SYSTEM_SECURITY_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_SYSTEM_SECURITY_MASTERED'."
    exit 1
fi

echo "PASS: Secure Linux Production System verified successfully."
exit 0
