#!/bin/bash
# validator.sh — linux-command-line-tools / 01-command-discovery / lnx-inspect-command-options
set -euo pipefail

FILE="$HOME/cli-test/cd_type.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'builtin' to ~/cli-test/cd_type.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "builtin" ]; then
  echo "FAIL: Expected 'builtin' in ~/cli-test/cd_type.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Shell command type verified successfully."
exit 0
