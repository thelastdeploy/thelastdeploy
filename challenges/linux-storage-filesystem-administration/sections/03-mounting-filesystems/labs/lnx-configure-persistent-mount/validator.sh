#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/mock_fstab"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

CONTENT=$(cat "$TARGET")

if ! echo "$CONTENT" | grep -Eq "UUID=a1b2c3d4-1234-5678-90ab-cdef12345678 +/mnt/data +ext4 +defaults +0 +2"; then
    echo "FAIL: $TARGET missing persistent mount entry 'UUID=a1b2c3d4-1234-5678-90ab-cdef12345678 /mnt/data ext4 defaults 0 2'."
    exit 1
fi

echo "PASS: Persistent fstab mount configuration verified."
exit 0
