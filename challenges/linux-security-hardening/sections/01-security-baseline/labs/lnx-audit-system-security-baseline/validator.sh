#!/bin/bash
set -euo pipefail

TARGET="$HOME/sec-test/baseline_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SECURITY_BASELINE_AUDITED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SECURITY_BASELINE_AUDITED'."
    exit 1
fi

echo "PASS: System security baseline audit verified."
exit 0
