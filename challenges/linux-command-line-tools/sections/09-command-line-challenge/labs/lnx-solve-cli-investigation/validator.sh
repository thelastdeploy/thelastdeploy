#!/bin/bash
# validator.sh — linux-command-line-tools / 09-command-line-challenge / lnx-solve-cli-investigation
set -euo pipefail

FILE="$HOME/cli-challenge/root_cause_ip.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '203.0.113.199' to ~/cli-challenge/root_cause_ip.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "203.0.113.199" ]; then
  echo "FAIL: Expected '203.0.113.199' in ~/cli-challenge/root_cause_ip.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Root cause IP identified correctly via CLI pipeline!"
exit 0
