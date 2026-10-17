#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/net-failure/network_drop_analysis.txt"

if [ ! -f "$TARGET" ] || [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is missing or empty."
    exit 1
fi

if grep -q "INTERMITTENT_PACKET_DROPS_TRACED_AND_FIXED" "$TARGET"; then
    echo "PASS: Trace Intermittent Network Drops verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Intermittent Network Drops."
    exit 1
fi
