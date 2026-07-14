#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-hcl-challenge"
FILE="$DIR/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf file not found in $DIR. Please write your configuration there."
  exit 1
fi
if ! grep -q 'resource[[:space:]]\+"local_file"[[:space:]]\+"welcome"' "$FILE"; then
  echo "FAIL: A resource block 'local_file' named 'welcome' is missing in main.tf."
  exit 1
fi
echo "PASS: First resource block created successfully."
exit 0
