#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-expr-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q -E '(lower|upper|trim|join|format)\(' "$FILE"; then
  echo "FAIL: Built-in string function (lower, upper, trim, join, format) not found in main.tf."
  exit 1
fi
echo "PASS: Built-in string function verified."
exit 0
