#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-expr-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q -E '(length|concat|flatten|element|slice)\(' "$FILE"; then
  echo "FAIL: Built-in collection function (length, concat, flatten, element, slice) not found in main.tf."
  exit 1
fi
echo "PASS: Built-in collection function verified."
exit 0
