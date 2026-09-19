#!/bin/bash
# validator.sh — linux-command-line-tools / 03-text-searching / lnx-investigate-log-patterns
set -euo pipefail

FILE="$HOME/grep-test/next_line.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save the line immediately following SIGSEGV to ~/grep-test/next_line.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
EXPECTED="Core dump written to /var/dumps/core.9902"

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "FAIL: Expected '$EXPECTED' in ~/grep-test/next_line.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Context line after SIGSEGV extracted successfully."
exit 0
