#!/bin/bash
# validator.sh — linux-filesystem-storage / 02-file-metadata / lnx-investigate-file-properties
set -euo pipefail

FILE="$HOME/metadata-test/file_type.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save the file format type ('gzip') to ~/metadata-test/file_type.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | tr '[:upper:]' '[:lower:]' | xargs)

if [[ "$CONTENT" != *"gzip"* ]]; then
  echo "FAIL: Recorded file type '$CONTENT' does not indicate 'gzip'."
  exit 1
fi

echo "PASS: File format type identified successfully."
exit 0
