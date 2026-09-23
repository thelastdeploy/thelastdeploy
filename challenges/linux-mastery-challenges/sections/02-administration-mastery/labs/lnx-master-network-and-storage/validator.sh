#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-admin/net_storage_mastery.log" ] && grep -q "NETWORK_AND_STORAGE_ORCHESTRATION_MASTERED" "$HOME/mastery-admin/net_storage_mastery.log"; then
    echo "PASS: Master Network and Storage verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Master Network and Storage."
    exit 1
fi
