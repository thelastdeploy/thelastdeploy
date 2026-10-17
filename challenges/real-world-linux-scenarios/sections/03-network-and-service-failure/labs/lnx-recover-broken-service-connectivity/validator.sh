#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/net-failure/connectivity_recovery.log"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "SERVICE_NETWORK_CONNECTIVITY_RESTORED" "$TARGET"; then
    echo "PASS: Recover Broken Service Connectivity verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Broken Service Connectivity."
    exit 1
fi
