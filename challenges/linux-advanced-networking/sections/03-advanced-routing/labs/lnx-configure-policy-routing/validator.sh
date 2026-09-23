#!/bin/bash
set -euo pipefail

TARGET="$HOME/route-test/rules_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "POLICY_ROUTING_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'POLICY_ROUTING_INSPECTED'."
    exit 1
fi

echo "PASS: Policy routing rules configuration verified."
exit 0
