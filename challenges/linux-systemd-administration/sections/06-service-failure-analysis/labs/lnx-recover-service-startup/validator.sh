#!/bin/bash
set -euo pipefail

FIXED="$HOME/fail-test/fixed.service"

if [ ! -f "$FIXED" ]; then
    echo "FAIL: $FIXED does not exist."
    exit 1
fi

if ! grep -q "ExecStart=/bin/echo" "$FIXED"; then
    echo "FAIL: $FIXED ExecStart was not repaired to valid executable."
    exit 1
fi

echo "PASS: Service startup recovery verified."
exit 0
