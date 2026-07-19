#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-resources-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file 'terraform.tfstate' not found. Make sure you ran 'terraform apply'."
  exit 1
fi
if ! grep -q '"type": "random_' "$DIR/terraform.tfstate"; then
  echo "FAIL: No random resource found in state file. Make sure you defined and applied a random resource (e.g. random_id or random_string)."
  exit 1
fi
echo "PASS: Random resource created and verified."
exit 0
