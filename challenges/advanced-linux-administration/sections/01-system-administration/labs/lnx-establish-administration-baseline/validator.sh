#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/sysadmin-audit/admin_baseline.conf"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "OPERATIONAL_ADMINISTRATION_BASELINE_ESTABLISHED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'OPERATIONAL_ADMINISTRATION_BASELINE_ESTABLISHED'."
    exit 1
fi

echo "PASS: Establish Administration Baseline verified successfully."
exit 0
