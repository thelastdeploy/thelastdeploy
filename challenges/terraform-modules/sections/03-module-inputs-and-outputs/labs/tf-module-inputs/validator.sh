#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-modules-challenge/main.tf"
if ! grep -q 'text[[:space:]]*=' "$FILE"; then
  echo "FAIL: Input variable argument 'text = ...' is missing in the module call block."
  exit 1
fi
echo "PASS: Module input arguments configured successfully."
exit 0
