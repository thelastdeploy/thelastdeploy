#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/storage-test/broken_app/mnt_missing_data"
FSTAB_MOCK="$HOME/storage-test/broken_app/fstab_mock"

if [ ! -d "$TARGET_DIR" ]; then
    echo "FAIL: Directory $TARGET_DIR was not created!"
    exit 1
fi

if [ ! -s "$FSTAB_MOCK" ]; then
    echo "FAIL: $FSTAB_MOCK does not exist or is empty."
    exit 1
fi

if ! grep -q "$TARGET_DIR" "$FSTAB_MOCK"; then
    echo "FAIL: $FSTAB_MOCK does not contain updated mount path $TARGET_DIR."
    exit 1
fi

echo "PASS: Storage mount point diagnosed and fstab_mock repaired."
exit 0
