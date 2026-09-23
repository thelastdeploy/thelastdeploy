#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-challenge/hardening.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "COMPROMISED_SERVER_HARDENED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'COMPROMISED_SERVER_HARDENED'."
    exit 1
fi

echo "PASS: Compromised server hardening capstone verified."
exit 0
