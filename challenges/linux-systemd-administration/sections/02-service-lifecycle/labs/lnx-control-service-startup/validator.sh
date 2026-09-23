#!/bin/bash
set -euo pipefail

TARGET="$HOME/service-test/boot_state.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "^ENABLE_STATE: " "$TARGET"; then
    echo "FAIL: $TARGET missing 'ENABLE_STATE: ' entry."
    exit 1
fi

echo "PASS: Service boot startup state verified."
exit 0
