#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if [ ! -d "$DIR/.terraform" ]; then
  echo "FAIL: Provider plugins not installed. Run 'terraform init' in $DIR."
  exit 1
fi
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Validation failed."
  exit 1
fi
echo "PASS: Provider initialized and validated successfully."
exit 0
