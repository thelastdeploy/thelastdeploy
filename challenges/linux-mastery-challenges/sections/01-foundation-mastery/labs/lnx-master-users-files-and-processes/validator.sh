#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/mastery-foundation/access_process_mastery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "USERS_FILES_AND_PROCESSES_MASTERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'USERS_FILES_AND_PROCESSES_MASTERED'."
    exit 1
fi

echo "PASS: Master Users, Files, and Processes verified successfully."
exit 0
