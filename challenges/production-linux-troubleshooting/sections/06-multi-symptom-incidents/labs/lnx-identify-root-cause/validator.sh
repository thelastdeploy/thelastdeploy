#!/bin/bash
set -euo pipefail

TARGET="$HOME/multi-inc-test/root_cause_proof.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "ROOT_CAUSE_PROVED:" "$TARGET"; then
    echo "FAIL: $TARGET missing 'ROOT_CAUSE_PROVED:'."
    exit 1
fi

echo "PASS: Production outage root cause identification verified."
exit 0
