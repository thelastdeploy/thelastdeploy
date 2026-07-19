#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-resources-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q 'depends_on' "$FILE"; then
  echo "FAIL: No explicit dependency 'depends_on' found in main.tf."
  exit 1
fi
echo "PASS: Explicit dependency verified."
exit 0
