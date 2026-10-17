#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/server-ops/operationalization_signoff.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PRODUCTION_SERVER_OPERATIONALIZED_AND_SECURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_SERVER_OPERATIONALIZED_AND_SECURED'."
    exit 1
fi

echo "PASS: Operate Production Linux Server Capstone verified successfully."
exit 0
