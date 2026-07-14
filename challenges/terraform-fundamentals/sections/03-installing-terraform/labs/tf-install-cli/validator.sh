#!/bin/bash
set -euo pipefail
if ! command -v terraform &>/dev/null; then
  echo "FAIL: terraform executable not found in system PATH. Install it via apt/brew."
  exit 1
fi
echo "PASS: Terraform CLI successfully found."
exit 0
