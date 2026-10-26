#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Run 'terraform import terraform_data.existing existing_id' in $DIR."
  exit 1
fi
if ! terraform -chdir="$DIR" state list 2>/dev/null | grep -q -E '(terraform_data\.existing|local_file\.existing)'; then
  echo "FAIL: Resource terraform_data.existing is not present in terraform.tfstate."
  exit 1
fi
echo "PASS: Resource imported into state successfully."
exit 0
