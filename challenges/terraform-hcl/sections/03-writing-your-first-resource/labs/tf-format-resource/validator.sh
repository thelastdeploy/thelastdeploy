#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-hcl-challenge"
if ! terraform -chdir="$DIR" fmt -check &>/dev/null; then
  echo "FAIL: Configurations in $DIR are not formatted correctly. Run 'terraform fmt'."
  exit 1
fi
echo "PASS: Configuration formatted successfully."
exit 0
