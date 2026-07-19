#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Reference error still present. Fix the resource reference typo (local_file.target_file.filename)."
  exit 1
fi
echo "PASS: Resource reference error resolved."
exit 0
