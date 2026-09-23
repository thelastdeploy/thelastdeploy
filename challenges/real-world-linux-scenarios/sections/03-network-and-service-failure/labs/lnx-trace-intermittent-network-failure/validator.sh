#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/net-failure/network_drop_analysis.txt" ] && grep -q "INTERMITTENT_PACKET_DROPS_TRACED_AND_FIXED" "$HOME/net-failure/network_drop_analysis.txt"; then
    echo "PASS: Trace Intermittent Network Drops verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Intermittent Network Drops."
    exit 1
fi
