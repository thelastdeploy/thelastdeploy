#!/bin/bash
set -euo pipefail

TARGET="$HOME/access-test/access_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "USER_ACCESS_HARDENED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'USER_ACCESS_HARDENED'."
    exit 1
fi

echo "PASS: User access controls hardening verified."
exit 0
