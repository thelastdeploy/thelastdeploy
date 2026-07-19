#!/bin/bash
set -euo pipefail
FILE="$HOME/terraform-modules-challenge/main.tf"
if ! grep -q 'module\.writer\.file_path' "$FILE"; then
  echo "FAIL: Module output reference 'module.writer.file_path' not found in root main.tf."
  exit 1
fi
echo "PASS: Module output value accessed successfully."
exit 0
