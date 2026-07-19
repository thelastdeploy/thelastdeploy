#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Run 'terraform import local_file.existing /tmp/existing.txt' in $DIR."
  exit 1
fi
if ! grep -q 'local_file.existing' "$DIR/terraform.tfstate"; then
  echo "FAIL: Resource local_file.existing is not present in terraform.tfstate."
  exit 1
fi
echo "PASS: Resource imported into state successfully."
exit 0
