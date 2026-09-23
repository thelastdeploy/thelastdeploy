#!/bin/bash
set -euo pipefail

TARGET="$HOME/container-net-test/net_trace.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CONTAINER_NET_TRACE_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CONTAINER_NET_TRACE_VERIFIED'."
    exit 1
fi

echo "PASS: Container network isolation tracing verified."
exit 0
