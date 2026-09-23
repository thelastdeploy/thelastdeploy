#!/bin/bash
set -euo pipefail

TARGET="$HOME/netns-test/ns_list.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "NETNS_INSPECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'NETNS_INSPECTED'."
    exit 1
fi

echo "PASS: Network namespace inspection verified."
exit 0
