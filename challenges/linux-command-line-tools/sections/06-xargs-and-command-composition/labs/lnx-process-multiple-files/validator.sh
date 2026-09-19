#!/bin/bash
# validator.sh — linux-command-line-tools / 06-xargs-and-command-composition / lnx-process-multiple-files
set -euo pipefail

FILE="$HOME/xargs-test/fail_count.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '3' to ~/xargs-test/fail_count.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "3" ]; then
  echo "FAIL: Expected '3' in ~/xargs-test/fail_count.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Batch file processing with xargs verified successfully."
exit 0
