#!/bin/bash
# validator.sh — linux-filesystem-storage / 06-filesystem-investigation / lnx-investigate-storage-usage
set -euo pipefail

FILE="$HOME/storage-investigation/culprit.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '.hidden_dump.log' to ~/storage-investigation/culprit.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != ".hidden_dump.log" ]; then
  echo "FAIL: Expected '.hidden_dump.log' in ~/storage-investigation/culprit.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Culprit storage file identified successfully."
exit 0
