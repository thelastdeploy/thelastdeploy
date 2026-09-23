#!/bin/bash
set -euo pipefail

TARGET="$HOME/res-outage-test/server_recovered.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "RESOURCE_STARVED_SERVER_RECOVERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'RESOURCE_STARVED_SERVER_RECOVERED'."
    exit 1
fi

echo "PASS: Resource-starved server recovery verified."
exit 0
