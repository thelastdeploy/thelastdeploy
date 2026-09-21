#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/partition_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -q "/dev/sdb1"; then
    echo "FAIL: $TARGET missing partition '/dev/sdb1'."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "/dev/sdb2"; then
    echo "FAIL: $TARGET missing partition '/dev/sdb2'."
    exit 1
fi

echo "PASS: Disk partition inspection verified."
exit 0
