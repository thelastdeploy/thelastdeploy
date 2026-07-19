#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-expr-challenge/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if grep -q '"hardcoded_value_123"' "$FILE"; then
  echo "FAIL: Hardcoded string 'hardcoded_value_123' still present in main.tf. Replace it with var or local reference."
  exit 1
fi
DIR="$HOME/terraform-expr-challenge"
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Configuration validation failed after refactoring."
  exit 1
fi
echo "PASS: Hardcoded configuration refactored and validated successfully."
exit 0
