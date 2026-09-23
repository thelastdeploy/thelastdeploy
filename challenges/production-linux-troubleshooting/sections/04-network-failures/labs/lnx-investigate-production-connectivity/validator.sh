#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-outage-test/net_diag.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "NETWORK_CONNECTIVITY_FAILURE_DIAGNOSED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'NETWORK_CONNECTIVITY_FAILURE_DIAGNOSED'."
    exit 1
fi

echo "PASS: Production network connectivity failure investigation verified."
exit 0
