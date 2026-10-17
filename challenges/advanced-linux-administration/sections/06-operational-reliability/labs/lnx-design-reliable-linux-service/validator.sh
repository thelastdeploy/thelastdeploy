#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/reliability/reliability_design.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "OPERATIONAL_RELIABILITY_HEALTHCHECK_ACTIVE" "$TARGET"; then
    echo "FAIL: $TARGET missing 'OPERATIONAL_RELIABILITY_HEALTHCHECK_ACTIVE'."
    exit 1
fi

echo "PASS: Design Reliable Linux Service verified successfully."
exit 0
