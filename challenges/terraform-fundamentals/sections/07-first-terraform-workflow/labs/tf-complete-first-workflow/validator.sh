#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file 'terraform.tfstate' not found in $DIR. Did you run 'terraform apply'?"
  exit 1
fi
if [ ! -f "/tmp/pet.txt" ]; then
  echo "FAIL: Target file /tmp/pet.txt was not created. Ensure you successfully ran the apply command."
  exit 1
fi
CONTENT=$(cat /tmp/pet.txt)
if [ "$CONTENT" != "We love pets!" ]; then
  echo "FAIL: Content of /tmp/pet.txt is incorrect. Got: '$CONTENT', expected: 'We love pets!'."
  exit 1
fi
echo "PASS: Successfully initialized, planned, and applied first Terraform workflow."
exit 0
