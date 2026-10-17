#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-challenge/topology.log"

SCRIPT="$HOME/net-challenge/setup_topology.sh"

if [ ! -f "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist."
    exit 1
fi

if [ ! -s "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT is empty."
    exit 1
fi

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "TOPOLOGY_BUILD_COMPLETE" "$TARGET"; then
    echo "FAIL: $TARGET missing 'TOPOLOGY_BUILD_COMPLETE'."
    exit 1
fi

echo "PASS: Isolated multi-namespace network topology capstone verified."
exit 0
