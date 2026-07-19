#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-expr-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q 'locals' "$FILE"; then
  echo "FAIL: No 'locals' block found in main.tf."
  exit 1
fi
if ! grep -q 'local\.' "$FILE"; then
  echo "FAIL: No reference to 'local.<name>' found in main.tf."
  exit 1
fi
echo "PASS: Local values utilized successfully."
exit 0
