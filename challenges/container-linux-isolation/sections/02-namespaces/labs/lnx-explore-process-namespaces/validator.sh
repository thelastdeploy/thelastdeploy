#!/bin/bash
set -euo pipefail

TARGET="$HOME/ns-test/ns_types.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "NAMESPACE_TYPES_EXPLORED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'NAMESPACE_TYPES_EXPLORED'."
    exit 1
fi

echo "PASS: Linux namespace types exploration verified."
exit 0
