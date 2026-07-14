#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-challenge"
if [ ! -d "$DIR/.terraform" ]; then
  echo "FAIL: .terraform folder not found. Make sure you run 'terraform init' inside $DIR."
  exit 1
fi
echo "PASS: Terraform workspace initialized successfully."
exit 0
