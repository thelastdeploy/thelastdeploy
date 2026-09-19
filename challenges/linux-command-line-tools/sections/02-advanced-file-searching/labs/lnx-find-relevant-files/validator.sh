#!/bin/bash
# validator.sh — linux-command-line-tools / 02-advanced-file-searching / lnx-find-relevant-files
set -euo pipefail

FILE="$HOME/search-test/audit_count.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '3' to ~/search-test/audit_count.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "3" ]; then
  echo "FAIL: Expected '3' in ~/search-test/audit_count.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Audit files counted correctly."
exit 0
