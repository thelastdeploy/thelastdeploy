#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-auto/automation_mastery.sh"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PRODUCTION_LINUX_AUTOMATION_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_LINUX_AUTOMATION_MASTERED'."
    exit 1
fi

echo "PASS: Automate Linux Operations verified successfully."
exit 0
