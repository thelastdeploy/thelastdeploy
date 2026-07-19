#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
if [ ! -f "$DIR/tfplan" ]; then
  echo "FAIL: Plan output file 'tfplan' not found in $DIR. Did you run 'terraform plan -out=tfplan'?"
  exit 1
fi
echo "PASS: Execution plan generated and saved successfully."
exit 0
