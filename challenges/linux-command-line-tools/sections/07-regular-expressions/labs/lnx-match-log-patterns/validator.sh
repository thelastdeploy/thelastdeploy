#!/bin/bash
# validator.sh — linux-command-line-tools / 07-regular-expressions / lnx-match-log-patterns
set -euo pipefail

FILE="$HOME/regex-test/ip_matches.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '3' to ~/regex-test/ip_matches.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "3" ]; then
  echo "FAIL: Expected '3' in ~/regex-test/ip_matches.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Extended regex IP pattern matching verified."
exit 0
