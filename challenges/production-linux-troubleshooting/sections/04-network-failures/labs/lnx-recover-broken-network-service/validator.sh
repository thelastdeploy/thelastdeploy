#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-outage-test/net_recovered.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "BROKEN_NETWORK_SERVICE_RECOVERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'BROKEN_NETWORK_SERVICE_RECOVERED'."
    exit 1
fi

echo "PASS: Broken network service recovery verified."
exit 0
