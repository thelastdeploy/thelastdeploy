#!/bin/bash
set -euo pipefail

TARGET="$HOME/sys-init-test/critical_chain.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CRITICAL_CHAIN_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CRITICAL_CHAIN_INSPECTED'."
    exit 1
fi

echo "PASS: Boot service startup order analysis verified."
exit 0
