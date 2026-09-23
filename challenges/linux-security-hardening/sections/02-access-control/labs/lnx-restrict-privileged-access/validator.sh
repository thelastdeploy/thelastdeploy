#!/bin/bash
set -euo pipefail

TARGET="$HOME/access-test/sudo_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SUDO_PRIVILEGES_RESTRICTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SUDO_PRIVILEGES_RESTRICTED'."
    exit 1
fi

echo "PASS: Privileged sudo access restriction verified."
exit 0
