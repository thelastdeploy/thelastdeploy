#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-hcl-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q '\${' "$FILE"; then
  echo "FAIL: You must use a string interpolation expression (e.g. \${...}) in main.tf."
  exit 1
fi
echo "PASS: String interpolation validated successfully."
exit 0
