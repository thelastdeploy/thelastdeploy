#!/bin/bash
# validator.sh — linux-command-line-tools / 03-text-searching / lnx-search-application-logs
set -euo pipefail

FILE="$HOME/grep-test/critical_count.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '2' to ~/grep-test/critical_count.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "2" ]; then
  echo "FAIL: Expected '2' in ~/grep-test/critical_count.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Application log search count verified."
exit 0
