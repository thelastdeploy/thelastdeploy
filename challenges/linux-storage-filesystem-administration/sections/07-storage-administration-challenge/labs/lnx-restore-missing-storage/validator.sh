#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/storage-challenge/mounts/app_data"
FSTAB_CFG="$HOME/storage-challenge/app/fstab_config"
STATUS_FILE="$HOME/storage-challenge/app/status.txt"

if [ ! -d "$TARGET_DIR" ]; then
    echo "FAIL: Target directory $TARGET_DIR does not exist!"
    exit 1
fi

PERMS=$(stat -c "%a" "$TARGET_DIR")
if [ "$PERMS" != "775" ]; then
    echo "FAIL: Permissions on $TARGET_DIR are $PERMS, expected 775."
    exit 1
fi

if [ ! -s "$FSTAB_CFG" ]; then
    echo "FAIL: fstab_config does not exist or is empty."
    exit 1
fi

if ! grep -q "$TARGET_DIR" "$FSTAB_CFG"; then
    echo "FAIL: fstab_config does not contain target mount path $TARGET_DIR."
    exit 1
fi

if [ ! -s "$STATUS_FILE" ]; then
    echo "FAIL: Status file $STATUS_FILE does not exist or is empty!"
    exit 1
fi

STATUS_CONTENT=$(tr -d '[:space:]' < "$STATUS_FILE")
if [ "$STATUS_CONTENT" != "STATUS:OK" ] && [ "$STATUS_CONTENT" != "STORAGE_STATUS:ONLINE" ]; then
    echo "FAIL: Status in $STATUS_FILE is '$STATUS_CONTENT', expected 'STATUS:OK'."
    exit 1
fi

echo "PASS: Storage volume restored and app status marked OK."
exit 0
