#!/bin/bash
# validator.sh — linux-command-line-tools / 05-pipelines / lnx-build-command-pipeline
set -euo pipefail

FILE="$HOME/pipe-test/top_poster.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '10.0.0.99' to ~/pipe-test/top_poster.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "10.0.0.99" ]; then
  echo "FAIL: Expected '10.0.0.99' in ~/pipe-test/top_poster.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Multi-stage pipeline result verified successfully."
exit 0
