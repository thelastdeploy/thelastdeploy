#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-hcl-challenge"
if [ ! -d "$DIR/.terraform" ]; then
  echo "FAIL: Directory not initialized. Run 'terraform init' in $DIR."
  exit 1
fi
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Configuration validation failed. Check syntax or arguments."
  exit 1
fi
echo "PASS: Project is initialized and validated successfully."
exit 0
