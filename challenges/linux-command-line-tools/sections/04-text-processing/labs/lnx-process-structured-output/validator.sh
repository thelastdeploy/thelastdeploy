#!/bin/bash
# validator.sh — linux-command-line-tools / 04-text-processing / lnx-process-structured-output
set -euo pipefail

FILE="$HOME/text-test/usernames.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Run 'cut -d',' -f2 ~/text-test/users.csv > ~/text-test/usernames.txt'."
  exit 1
fi

CONTENT=$(tr -d '\r' < "$FILE" | xargs)
EXPECTED="alice bob charlie"

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "FAIL: Expected '$EXPECTED' in ~/text-test/usernames.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Structured CSV output processed successfully."
exit 0
