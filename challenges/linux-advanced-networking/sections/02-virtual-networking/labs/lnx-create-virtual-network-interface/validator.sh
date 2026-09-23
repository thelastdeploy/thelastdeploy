#!/bin/bash
set -euo pipefail

TARGET="$HOME/vnet-test/vif_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "DUMMY_INTERFACE_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'DUMMY_INTERFACE_VERIFIED'."
    exit 1
fi

echo "PASS: Virtual network interface creation verified."
exit 0
