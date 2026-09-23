#!/bin/bash
set -euo pipefail

TARGET="$HOME/res-outage-test/exhaustion_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "RESOURCE_EXHAUSTION_DIAGNOSED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'RESOURCE_EXHAUSTION_DIAGNOSED'."
    exit 1
fi

echo "PASS: Severe resource exhaustion investigation verified."
exit 0
