#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-resources-challenge"
FILE="$DIR/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q 'data[[:space:]]\+"local_file"' "$FILE"; then
  echo "FAIL: No 'data "local_file"' block found in main.tf."
  exit 1
fi
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Make sure you ran 'terraform apply'."
  exit 1
fi
echo "PASS: Data source read and applied successfully."
exit 0
