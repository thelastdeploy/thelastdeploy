#!/bin/bash
set -euo pipefail

TARGET="$HOME/pv-test/pv_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PV_CREATE_COMMAND_VERIFIED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PV_CREATE_COMMAND_VERIFIED'."
    exit 1
fi

echo "PASS: Physical volume creation command verified."
exit 0
