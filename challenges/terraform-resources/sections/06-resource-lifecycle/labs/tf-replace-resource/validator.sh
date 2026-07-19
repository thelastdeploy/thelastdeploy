#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-resources-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q 'create_before_destroy[[:space:]]*=[[:space:]]*true' "$FILE"; then
  echo "FAIL: The lifecycle configuration 'create_before_destroy = true' is missing."
  exit 1
fi
echo "PASS: Resource lifecycle configuration verified."
exit 0
