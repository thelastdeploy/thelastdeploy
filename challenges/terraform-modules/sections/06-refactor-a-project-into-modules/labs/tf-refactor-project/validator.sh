#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-modules-challenge"
if [ ! -d "$DIR/modules" ]; then
  echo "FAIL: 'modules' directory not created in $DIR."
  exit 1
fi
if ! grep -q 'module' "$DIR/main.tf"; then
  echo "FAIL: Root main.tf does not invoke any child module."
  exit 1
fi
if ! terraform -chdir="$DIR" validate &>/dev/null; then
  echo "FAIL: Project validation failed after refactoring."
  exit 1
fi
echo "PASS: Monolithic project refactored into modules successfully."
exit 0
