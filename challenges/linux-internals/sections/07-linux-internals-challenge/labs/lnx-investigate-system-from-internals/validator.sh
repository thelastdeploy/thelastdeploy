#!/bin/bash
set -euo pipefail

TARGET="$HOME/internals-challenge/investigation.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_BEHAVIOR_INVESTIGATED_FROM_INTERNALS: ROOT_CAUSE_PROVED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_BEHAVIOR_INVESTIGATED_FROM_INTERNALS: ROOT_CAUSE_PROVED'."
    exit 1
fi

echo "PASS: System behavior investigation from Linux internals capstone verified."
exit 0
