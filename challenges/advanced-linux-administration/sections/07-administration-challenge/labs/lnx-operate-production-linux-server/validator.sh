#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/server-ops/operationalization_signoff.log" ] && grep -q "PRODUCTION_SERVER_OPERATIONALIZED_AND_SECURED" "$HOME/server-ops/operationalization_signoff.log"; then
    echo "PASS: Operate Production Linux Server Capstone verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Operate Production Linux Server Capstone."
    exit 1
fi
