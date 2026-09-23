#!/bin/bash
set -euo pipefail

TARGET="$HOME/isolation-challenge/isolation_fix.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CONTAINER_ISOLATION_REPAIRED: SUCCESS" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CONTAINER_ISOLATION_REPAIRED: SUCCESS'."
    exit 1
fi

echo "PASS: Container isolation debugging capstone verified."
exit 0
