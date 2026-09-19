#!/bin/bash
# validator.sh — linux-filesystem-storage / 03-links-and-inodes / lnx-identify-file-links
set -euo pipefail

RESULT_FILE="$HOME/link-test/same_inode.txt"
if [ ! -f "$RESULT_FILE" ]; then
  echo "FAIL: File $RESULT_FILE not found. Save the filename sharing the inode of original.txt ('file_b.txt') to ~/link-test/same_inode.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$RESULT_FILE" | xargs)
if [ "$CONTENT" != "file_b.txt" ]; then
  echo "FAIL: Expected 'file_b.txt' in ~/link-test/same_inode.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Hard-linked inode file identified successfully."
exit 0
