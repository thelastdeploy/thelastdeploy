#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-hcl-challenge"
FILE="$DIR/main.tf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: main.tf not found."
  exit 1
fi
if ! grep -q -E '(^|[^/])(//|#)' "$FILE" && ! grep -q '/\*' "$FILE"; then
  echo "FAIL: No comments found in main.tf. Add a comment explaining your resource."
  exit 1
fi
if ! terraform -chdir="$DIR" fmt -check &>/dev/null; then
  echo "FAIL: Configuration is not formatted correctly. Run 'terraform fmt'."
  exit 1
fi
echo "PASS: Configuration commented and formatted successfully."
exit 0
