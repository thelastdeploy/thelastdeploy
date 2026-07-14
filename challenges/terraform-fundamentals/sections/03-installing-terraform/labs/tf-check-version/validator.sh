#!/bin/bash
set -euo pipefail
if ! terraform -version &>/dev/null; then
  echo "FAIL: Failed to run 'terraform -version'."
  exit 1
fi
echo "PASS: Terraform CLI is operational."
exit 0
