#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-expr-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf file not found."
  exit 1
fi
if ! grep -q 'default' "$FILE"; then
  echo "FAIL: No 'default' attribute found in the variable block."
  exit 1
fi
echo "PASS: Default value defined successfully."
exit 0
