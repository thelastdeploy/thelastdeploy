#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Validation failed. Remove invalid parameters and fix attribute names."
  exit 1
fi
echo "PASS: Validation errors resolved."
exit 0
