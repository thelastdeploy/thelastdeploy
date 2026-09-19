#!/bin/bash
# validator.sh — linux-command-line-tools / 08-cli-investigation / lnx-investigate-messy-log
set -euo pipefail

FILE="$HOME/cli-investigation/bad_user.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'user_88' to ~/cli-investigation/bad_user.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "user_88" ]; then
  echo "FAIL: Expected 'user_88' in ~/cli-investigation/bad_user.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Bad user ID identified correctly from messy log dump."
exit 0
