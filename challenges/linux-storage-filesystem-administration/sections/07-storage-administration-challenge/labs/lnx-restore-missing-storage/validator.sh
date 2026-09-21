#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/storage-challenge/mounts/app_data"
FSTAB_CFG="$HOME/storage-challenge/app/fstab_config"
STATUS_FILE="$HOME/storage-challenge/app/status.txt"

if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: Target directory $TARGET_DIR does not exist!"
    exit 1
fi

PERMS=$(stat -c "%a" "$TARGET_DIR")
if [ "$PERMS" != "775" ]; then
    echo "ERROR: Permissions on $TARGET_DIR are $PERMS, expected 775."
    exit 1
fi

if ! grep -q "$TARGET_DIR" "$FSTAB_CFG"; then
    echo "ERROR: fstab_config does not contain target mount path $TARGET_DIR."
    exit 1
fi

if [ ! -f "$STATUS_FILE" ]; then
    echo "ERROR: Status file $STATUS_FILE does not exist!"
    exit 1
fi

STATUS_CONTENT=$(tr -d '[:space:]' < "$STATUS_FILE")
if [ "$STATUS_CONTENT" != "STATUS:OK" ]; then
    echo "ERROR: Status in $STATUS_FILE is '$STATUS_CONTENT', expected 'STATUS:OK'."
    exit 1
fi

echo "SUCCESS: Storage volume restored and app status marked OK."
exit 0
