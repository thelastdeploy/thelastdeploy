#!/bin/bash
# validator.sh — linux-filesystem-storage / 04-disk-usage / lnx-check-disk-space
set -euo pipefail

FILE="$HOME/disk-test/root_mount.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '/' to ~/disk-test/root_mount.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "/" ]; then
  echo "FAIL: Expected '/' in ~/disk-test/root_mount.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Root mount point successfully recorded."
exit 0
