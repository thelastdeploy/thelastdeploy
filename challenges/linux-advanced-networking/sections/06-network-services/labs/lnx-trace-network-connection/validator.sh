#!/bin/bash
set -euo pipefail

TARGET="$HOME/svc-net-test/trace_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PACKET_TRACE_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PACKET_TRACE_VERIFIED'."
    exit 1
fi

echo "PASS: Network connection flow tracing verified."
exit 0
