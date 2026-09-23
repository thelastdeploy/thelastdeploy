#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-sec-test/ports_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "UNNECESSARY_PORTS_RESTRICTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'UNNECESSARY_PORTS_RESTRICTED'."
    exit 1
fi

echo "PASS: Unnecessary port restriction verified."
exit 0
