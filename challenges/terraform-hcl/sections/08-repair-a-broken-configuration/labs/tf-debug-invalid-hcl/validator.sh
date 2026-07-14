#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-hcl-challenge"
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Configuration validation failed. Ensure arguments are properly set with '=' (e.g. filename = \"/tmp/broken.txt\")."
  exit 1
fi
echo "PASS: Configuration debugged and fixed successfully."
exit 0
