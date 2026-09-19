#!/bin/bash
# validator.sh — linux-command-line-tools / 07-regular-expressions / lnx-extract-patterned-data
set -euo pipefail

FILE="$HOME/regex-test/error_status_count.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '3' to ~/regex-test/error_status_count.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "3" ]; then
  echo "FAIL: Expected '3' in ~/regex-test/error_status_count.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: HTTP error status count verified."
exit 0
