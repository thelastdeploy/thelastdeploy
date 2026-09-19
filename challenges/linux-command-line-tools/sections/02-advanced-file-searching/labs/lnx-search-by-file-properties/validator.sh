#!/bin/bash
# validator.sh — linux-command-line-tools / 02-advanced-file-searching / lnx-search-by-file-properties
set -euo pipefail

FILE="$HOME/search-test/large_log.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'oversized.log' to ~/search-test/large_log.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "oversized.log" ]; then
  echo "FAIL: Expected 'oversized.log' in ~/search-test/large_log.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Large file located successfully."
exit 0
