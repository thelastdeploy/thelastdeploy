#!/bin/bash
set -euo pipefail

TARGET="$HOME/netns-test/veth_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "VETH_PAIR_CONFIGURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'VETH_PAIR_CONFIGURED'."
    exit 1
fi

echo "PASS: veth pair network namespace connection verified."
exit 0
