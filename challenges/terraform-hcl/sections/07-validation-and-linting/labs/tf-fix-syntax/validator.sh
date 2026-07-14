#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-hcl-challenge"
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: There are still syntax errors in main.tf. Please check and fix the resource block brackets."
  exit 1
fi
echo "PASS: Syntax errors fixed and configuration validated."
exit 0
