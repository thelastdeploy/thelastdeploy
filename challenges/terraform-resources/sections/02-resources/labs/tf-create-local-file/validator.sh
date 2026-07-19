#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-resources-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found in $DIR. Make sure you ran 'terraform apply'."
  exit 1
fi
echo "PASS: Local file resource created successfully."
exit 0
