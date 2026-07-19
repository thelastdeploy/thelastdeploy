#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Module validation failed. Pass the required 'val' input variable in the module block."
  exit 1
fi
echo "PASS: Module invocation error resolved."
exit 0
