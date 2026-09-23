#!/bin/bash
set -euo pipefail

TARGET="$HOME/route-test/route_debug.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "ROUTE_LOOKUP_SUCCESS: 127.0.0.1" "$TARGET"; then
    echo "FAIL: $TARGET missing 'ROUTE_LOOKUP_SUCCESS: 127.0.0.1'."
    exit 1
fi

echo "PASS: Multi-route network debug verified."
exit 0
