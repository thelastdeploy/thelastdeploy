#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-challenge"
if ! terraform -chdir="$DIR" fmt -check &>/dev/null; then
  echo "FAIL: Files in $DIR are not properly formatted. Run 'terraform fmt' inside that directory."
  exit 1
fi
echo "PASS: Configurations formatted correctly."
exit 0
