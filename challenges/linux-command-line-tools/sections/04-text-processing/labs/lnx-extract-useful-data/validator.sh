#!/bin/bash
# validator.sh — linux-command-line-tools / 04-text-processing / lnx-extract-useful-data
set -euo pipefail

FILE="$HOME/text-test/ip_count.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '4' to ~/text-test/ip_count.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "4" ]; then
  echo "FAIL: Expected '4' in ~/text-test/ip_count.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Recurring log pattern count extracted successfully."
exit 0
