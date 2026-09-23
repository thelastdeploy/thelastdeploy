#!/bin/bash
set -euo pipefail

TARGET="$HOME/lvm-test/lvm_hierarchy.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "1. Physical Volume" "$TARGET" || ! grep -q "5. Mount Point" "$TARGET"; then
    echo "FAIL: $TARGET missing expected LVM hierarchy layers."
    exit 1
fi

echo "PASS: LVM components and hierarchy verified."
exit 0
