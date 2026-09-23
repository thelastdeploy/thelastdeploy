#!/bin/bash
set -euo pipefail

TARGET="$HOME/ns-test/unshare_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "UNSHARE_NAMESPACE_CREATED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'UNSHARE_NAMESPACE_CREATED'."
    exit 1
fi

echo "PASS: Isolated namespace environment creation verified."
exit 0
