#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/admin-auto/automation_tasks.sh"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "ADMINISTRATION_TASKS_AUTOMATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'ADMINISTRATION_TASKS_AUTOMATED'."
    exit 1
fi

echo "PASS: Automate Administration Tasks verified successfully."
exit 0
