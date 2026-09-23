#!/bin/bash
set -euo pipefail

TARGET="$HOME/net-inv-test/diag_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "ISOLATION_CHECK: ALL_LAYERS_HEALTHY" "$TARGET"; then
    echo "FAIL: $TARGET missing 'ISOLATION_CHECK: ALL_LAYERS_HEALTHY'."
    exit 1
fi

echo "PASS: Network isolation investigation verified."
exit 0
