#!/bin/bash
set -euo pipefail

TARGET="$HOME/ns-test/ns_debug.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "NAMESPACE_ISOLATION_DEBUGGED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'NAMESPACE_ISOLATION_DEBUGGED'."
    exit 1
fi

echo "PASS: Namespace isolation debugging verified."
exit 0
