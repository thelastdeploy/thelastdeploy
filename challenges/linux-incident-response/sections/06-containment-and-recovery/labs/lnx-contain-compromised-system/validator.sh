#!/bin/bash
set -euo pipefail

TARGET="$HOME/recovery-test/containment_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "COMPROMISED_SYSTEM_CONTAINED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'COMPROMISED_SYSTEM_CONTAINED'."
    exit 1
fi

echo "PASS: Compromised system containment verified."
exit 0
