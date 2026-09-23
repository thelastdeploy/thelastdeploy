#!/bin/bash
set -euo pipefail

TARGET="$HOME/boot-capstone/recovery.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "UNBOOTABLE_SYSTEM_RECOVERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'UNBOOTABLE_SYSTEM_RECOVERED'."
    exit 1
fi

echo "PASS: Unbootable system recovery capstone verified."
exit 0
