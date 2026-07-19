#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-expr-challenge"
if [ ! -f "$DIR/terraform.tfvars" ]; then
  echo "FAIL: terraform.tfvars file not found in $DIR."
  exit 1
fi
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Make sure you ran 'terraform apply'."
  exit 1
fi
echo "PASS: terraform.tfvars configuration applied successfully."
exit 0
