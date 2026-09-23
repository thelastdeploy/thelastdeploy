#!/bin/bash
set -euo pipefail

TARGET="$HOME/audit-test/compliance.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_HARDENING_VERIFIED: PASS" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_HARDENING_VERIFIED: PASS'."
    exit 1
fi

echo "PASS: System hardening verification and compliance audit verified."
exit 0
