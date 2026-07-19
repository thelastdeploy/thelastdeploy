#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-resources-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found in $DIR."
  exit 1
fi
if [ -f "/tmp/temp.txt" ]; then
  echo "FAIL: The resource has not been destroyed. Run 'terraform destroy' inside $DIR."
  exit 1
fi
echo "PASS: Resource destroyed successfully."
exit 0
