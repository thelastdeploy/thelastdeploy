#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-expr-challenge"
FILE="$DIR/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q 'output' "$FILE"; then
  echo "FAIL: No 'output' block found in main.tf."
  exit 1
fi
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Run 'terraform apply'."
  exit 1
fi
if ! grep -q '"outputs":' "$DIR/terraform.tfstate"; then
  echo "FAIL: No output registered in terraform.tfstate."
  exit 1
fi
echo "PASS: Output value created and verified."
exit 0
