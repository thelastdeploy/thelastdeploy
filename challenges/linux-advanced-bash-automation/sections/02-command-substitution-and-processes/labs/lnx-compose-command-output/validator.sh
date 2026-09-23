#!/bin/bash
set -euo pipefail

TARGET="$HOME/sub-test/system_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "^ARCH: " "$TARGET"; then
    echo "FAIL: $TARGET missing 'ARCH: ' entry."
    exit 1
fi

if ! grep -q "^USER: " "$TARGET"; then
    echo "FAIL: $TARGET missing 'USER: ' entry."
    exit 1
fi

if ! grep -q "^DATE: " "$TARGET"; then
    echo "FAIL: $TARGET missing 'DATE: ' entry."
    exit 1
fi

echo "PASS: System info command output verified."
exit 0
