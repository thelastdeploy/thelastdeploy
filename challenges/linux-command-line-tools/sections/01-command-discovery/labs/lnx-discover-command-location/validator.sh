#!/bin/bash
# validator.sh — linux-command-line-tools / 01-command-discovery / lnx-discover-command-location
set -euo pipefail

FILE="$HOME/cli-test/grep_location.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Run 'which grep > ~/cli-test/grep_location.txt'."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
EXPECTED=$(which grep 2>/dev/null || echo "/usr/bin/grep")

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "FAIL: Expected '$EXPECTED' in ~/cli-test/grep_location.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Executable binary location discovered successfully."
exit 0
