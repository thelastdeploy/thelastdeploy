#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if ! terraform -chdir="$DIR" fmt -check &>/dev/null; then
  echo "FAIL: Configuration still has syntax or formatting issues."
  exit 1
fi
echo "PASS: Syntax errors fixed successfully."
exit 0
