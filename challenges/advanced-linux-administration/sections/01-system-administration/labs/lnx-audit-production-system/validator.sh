#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/sysadmin-audit/system_inventory.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PRODUCTION_SERVER_AUDIT_COMPLETED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_SERVER_AUDIT_COMPLETED'."
    exit 1
fi

echo "PASS: Audit Production System verified successfully."
exit 0
