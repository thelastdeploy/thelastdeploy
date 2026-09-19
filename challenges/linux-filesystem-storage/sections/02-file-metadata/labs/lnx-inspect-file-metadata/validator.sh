#!/bin/bash
# validator.sh — linux-filesystem-storage / 02-file-metadata / lnx-inspect-file-metadata
set -euo pipefail

FILE="$HOME/metadata-test/file_size.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save the byte size of target_file.txt to ~/metadata-test/file_size.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
EXPECTED=$(wc -c < "$HOME/metadata-test/target_file.txt" | tr -d ' ')

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "FAIL: Recorded byte size ($CONTENT) does not match actual byte size ($EXPECTED)."
  exit 1
fi

echo "PASS: File metadata byte size verified successfully."
exit 0
