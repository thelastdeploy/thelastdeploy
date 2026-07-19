#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-modules-challenge"
FILE="$DIR/main.tf"
if ! grep -q 'module[[:space:]]\+"[a-zA-Z0-9_-]\+"' "$FILE"; then
  echo "FAIL: No module block declaration found in root main.tf."
  exit 1
fi
if [ ! -d "$DIR/.terraform/modules" ]; then
  echo "FAIL: Modules not initialized. Run 'terraform init' in $DIR."
  exit 1
fi
echo "PASS: Child module called and initialized successfully."
exit 0
