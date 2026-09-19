#!/bin/bash
# validator.sh — linux-filesystem-storage / 01-filesystem-hierarchy / lnx-explore-filesystem
set -euo pipefail

FILE="$HOME/log_path.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save the absolute path of the standard log directory (/var/log) to ~/log_path.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "/var/log" ]; then
  echo "FAIL: Expected '/var/log' in ~/log_path.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Standard log directory path successfully recorded."
exit 0
