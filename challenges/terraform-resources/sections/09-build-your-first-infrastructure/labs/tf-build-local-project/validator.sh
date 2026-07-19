#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-resources-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file 'terraform.tfstate' not found. Please apply your configuration."
  exit 1
fi
RESOURCE_COUNT=$(grep -o '"mode":' "$DIR/terraform.tfstate" | wc -l)
if [ "$RESOURCE_COUNT" -lt 2 ]; then
  echo "FAIL: Expected at least 2 resources in the applied state, found: $RESOURCE_COUNT. Build a project combining multiple resources."
  exit 1
fi
echo "PASS: Local infrastructure project successfully provisioned and verified."
exit 0
