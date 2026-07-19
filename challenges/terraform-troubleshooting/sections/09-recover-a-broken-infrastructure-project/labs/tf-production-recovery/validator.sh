#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if [ ! -d "$DIR/.terraform" ]; then
  echo "FAIL: Directory not initialized. Run 'terraform init' in $DIR."
  exit 1
fi
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Validation failed. Remove invalid parameters from main.tf."
  exit 1
fi
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Run 'terraform apply' to restore infrastructure."
  exit 1
fi
if [ ! -f "/tmp/prod_rec.txt" ]; then
  echo "FAIL: Production file /tmp/prod_rec.txt was not created."
  exit 1
fi
echo "PASS: Production infrastructure project recovered and verified successfully."
exit 0
