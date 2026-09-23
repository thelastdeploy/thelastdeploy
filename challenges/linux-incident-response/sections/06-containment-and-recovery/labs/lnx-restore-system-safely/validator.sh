#!/bin/bash
set -euo pipefail

TARGET="$HOME/recovery-test/restoration_report.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_RESTORED_SAFELY" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_RESTORED_SAFELY'."
    exit 1
fi

echo "PASS: Safe system restoration verified."
exit 0
