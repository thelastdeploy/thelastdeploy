#!/bin/bash
set -euo pipefail

TARGET="$HOME/trace-test/hidden_activity.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "HIDDEN_ACTIVITY_INVESTIGATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'HIDDEN_ACTIVITY_INVESTIGATED'."
    exit 1
fi

echo "PASS: Hidden system activity investigation verified."
exit 0
