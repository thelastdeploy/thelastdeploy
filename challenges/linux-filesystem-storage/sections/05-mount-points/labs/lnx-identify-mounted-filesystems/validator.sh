#!/bin/bash
# validator.sh — linux-filesystem-storage / 05-mount-points / lnx-identify-mounted-filesystems
set -euo pipefail

FILE="$HOME/mount-test/proc_fstype.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'proc' to ~/mount-test/proc_fstype.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "proc" ]; then
  echo "FAIL: Expected 'proc' in ~/mount-test/proc_fstype.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Mount point filesystem type verified successfully."
exit 0
