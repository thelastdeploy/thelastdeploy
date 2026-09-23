#!/bin/bash
set -euo pipefail

TARGET="$HOME/target-test/deps.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "DEPENDENCIES_ANALYZED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'DEPENDENCIES_ANALYZED'."
    exit 1
fi

echo "PASS: Service dependency analysis verified."
exit 0
