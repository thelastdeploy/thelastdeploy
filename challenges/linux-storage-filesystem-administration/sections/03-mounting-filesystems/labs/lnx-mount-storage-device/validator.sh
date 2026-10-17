#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$HOME/storage-test/mount_cmd.sh"

if [ ! -s "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH does not exist or is empty."
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: $SCRIPT_PATH is not executable."
    exit 1
fi

CONTENT=$(cat "$SCRIPT_PATH")

if ! echo "$CONTENT" | grep -Eq "mount[[:space:]]+/dev/sdb1[[:space:]]+/mnt/appdata"; then
    echo "FAIL: $SCRIPT_PATH missing 'mount /dev/sdb1 /mnt/appdata'."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq "umount[[:space:]]+(/mnt/appdata|/dev/sdb1)"; then
    echo "FAIL: $SCRIPT_PATH missing 'umount /mnt/appdata'."
    exit 1
fi

echo "PASS: Mount and unmount command syntax verified."
exit 0
