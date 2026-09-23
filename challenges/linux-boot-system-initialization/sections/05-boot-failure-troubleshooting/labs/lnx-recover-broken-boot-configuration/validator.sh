#!/bin/bash
set -euo pipefail

TARGET="$HOME/boot-fail-test/fstab.fixed"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "nofail" "$TARGET" && ! grep -q "#" "$TARGET"; then
    echo "FAIL: $TARGET fstab entry was not fixed with nofail or commented out."
    exit 1
fi

echo "PASS: Broken boot configuration recovery verified."
exit 0
