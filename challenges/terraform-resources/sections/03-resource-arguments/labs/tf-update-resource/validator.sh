#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-resources-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found in $DIR."
  exit 1
fi
if [ ! -f "/tmp/app.txt" ]; then
  echo "FAIL: Target file /tmp/app.txt not found."
  exit 1
fi
CONTENT=$(cat /tmp/app.txt)
if [ "$CONTENT" = "v1" ]; then
  echo "FAIL: Resource content has not been updated. Modify content and run 'terraform apply'."
  exit 1
fi
echo "PASS: Resource argument updated and applied successfully."
exit 0
