#!/bin/bash
set -euo pipefail

TARGET="$HOME/svc-outage-test/outage_diag.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SERVICE_OUTAGE_DIAGNOSED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SERVICE_OUTAGE_DIAGNOSED'."
    exit 1
fi

echo "PASS: Production service outage investigation verified."
exit 0
