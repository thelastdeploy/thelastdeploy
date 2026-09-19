#!/bin/bash
# validator.sh — linux-filesystem-storage / 04-disk-usage / lnx-find-large-files
set -euo pipefail

RESULT="$HOME/disk-test/largest_file.txt"
if [ ! -f "$RESULT" ]; then
  echo "FAIL: File $RESULT not found. Save the largest filename ('heavy_dump.log') to ~/disk-test/largest_file.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$RESULT" | xargs)
if [ "$CONTENT" != "heavy_dump.log" ]; then
  echo "FAIL: Expected 'heavy_dump.log' in ~/disk-test/largest_file.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Space-consuming file identified successfully."
exit 0
