#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-foundation/basics_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "FOUNDATION_SYSTEM_BASICS_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FOUNDATION_SYSTEM_BASICS_MASTERED'."
    exit 1
fi

echo "PASS: Master Linux System Basics verified successfully."
exit 0
