#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-challenge"
if [ ! -d "$DIR/.terraform" ]; then
  echo "FAIL: Workspace not initialized. Run 'terraform init' in $DIR"
  exit 1
fi
if ! terraform -chdir="$DIR" fmt -check &>/dev/null; then
  echo "FAIL: Configuration file not formatted. Run 'terraform fmt' in $DIR"
  exit 1
fi
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Configuration validation failed. Run 'terraform validate' in $DIR to check syntax errors."
  exit 1
fi
echo "PASS: Configuration validated and formatted successfully."
exit 0
