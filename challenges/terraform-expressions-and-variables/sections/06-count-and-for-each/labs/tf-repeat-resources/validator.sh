#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-expr-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q -E '(count|for_each)[[:space:]]*=' "$FILE"; then
  echo "FAIL: Neither 'count' nor 'for_each' meta-argument found in main.tf."
  exit 1
fi
DIR="$HOME/terraform-expr-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Make sure you ran 'terraform apply'."
  exit 1
fi
echo "PASS: Resource repetition validated successfully."
exit 0
