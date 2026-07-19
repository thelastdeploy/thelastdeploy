#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
CONTENT=$(cat /tmp/drift.txt 2>/dev/null || true)
if [ "$CONTENT" = "out_of_band_change" ]; then
  PLAN_OUT=$(terraform -chdir="$DIR" plan 2>&1)
  if ! echo "$PLAN_OUT" | grep -q -E '(update in-place|must be replaced|will be updated)'; then
    echo "FAIL: State drift was not detected by Terraform plan."
    exit 1
  fi
fi
echo "PASS: State drift detection verified."
exit 0
