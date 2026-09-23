#!/bin/bash
set -euo pipefail

TARGET="$HOME/fw-test/fw_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "FIREWALL_CHAINS_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FIREWALL_CHAINS_INSPECTED'."
    exit 1
fi

echo "PASS: Firewall rules inspection verified."
exit 0
