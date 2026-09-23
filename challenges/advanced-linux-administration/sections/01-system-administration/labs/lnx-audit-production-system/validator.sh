#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/sysadmin-audit/system_inventory.log" ] && grep -q "PRODUCTION_SERVER_AUDIT_COMPLETED" "$HOME/sysadmin-audit/system_inventory.log"; then
    echo "PASS: Audit Production System verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Audit Production System."
    exit 1
fi
