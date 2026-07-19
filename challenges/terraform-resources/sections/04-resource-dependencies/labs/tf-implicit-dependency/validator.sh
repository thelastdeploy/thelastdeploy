#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-resources-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q -E '[a-zA-Z0-9_]+\.[a-zA-Z0-9_]+\.[a-zA-Z0-9_]+' "$FILE"; then
  echo "FAIL: No implicit dependency (resource reference expression) found in main.tf."
  exit 1
fi
echo "PASS: Implicit dependency verified."
exit 0
