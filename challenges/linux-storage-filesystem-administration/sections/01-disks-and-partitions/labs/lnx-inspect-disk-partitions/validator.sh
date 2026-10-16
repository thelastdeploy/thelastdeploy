#!/bin/bash
set -euo pipefail

TARGET="$HOME/storage-test/partition_info.txt"

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist or is empty."
    exit 1
fi

CONTENT=$(cat "$TARGET")

# Check for simulated partition layout with /dev/sdb1 and /dev/sdb2
if echo "$CONTENT" | grep -q "/dev/sdb1" && echo "$CONTENT" | grep -q "/dev/sdb2"; then
    echo "PASS: Disk partition inspection verified."
    exit 0
fi

# Also accept live fdisk or parted output with partition table information
if echo "$CONTENT" | grep -Eq "(Disk|Device|Units|Sector|Linux|GPT|MBR|parted|Partition Table)" && echo "$CONTENT" | grep -Eq "(p[0-9]|sd[a-z][0-9]|vd[a-z][0-9]|nvme[0-9]n[0-9]p[0-9])"; then
    echo "PASS: Disk partition inspection verified."
    exit 0
fi

echo "FAIL: $TARGET does not contain valid disk partition layout details."
exit 1
