#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/linux-mastery/grand_mastery_completion.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "GRAND_LINUX_MASTERY_TRACK_COMPLETED_SUCCESSFULLY" "$TARGET"; then
    echo "FAIL: $TARGET missing 'GRAND_LINUX_MASTERY_TRACK_COMPLETED_SUCCESSFULLY'."
    exit 1
fi

echo "PASS: Complete Linux Mastery Grand Capstone verified successfully."
exit 0
