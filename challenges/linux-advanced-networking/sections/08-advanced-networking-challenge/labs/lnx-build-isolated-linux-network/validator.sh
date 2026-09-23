#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-challenge/topology.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "TOPOLOGY_BUILD_COMPLETE" "$TARGET"; then
    echo "FAIL: $TARGET missing 'TOPOLOGY_BUILD_COMPLETE'."
    exit 1
fi

echo "PASS: Isolated multi-namespace network topology capstone verified."
exit 0
