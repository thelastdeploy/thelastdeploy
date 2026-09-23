#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/net-failure/connectivity_recovery.log" ] && grep -q "SERVICE_NETWORK_CONNECTIVITY_RESTORED" "$HOME/net-failure/connectivity_recovery.log"; then
    echo "PASS: Recover Broken Service Connectivity verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Broken Service Connectivity."
    exit 1
fi
