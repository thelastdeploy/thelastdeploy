#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-outage-test/storage_recovered.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "STORAGE_SYSTEM_RECOVERED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'STORAGE_SYSTEM_RECOVERED'."
    exit 1
fi

echo "PASS: Failing storage system recovery verified."
exit 0
