#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-troubleshoot-challenge"
if [ ! -f "$DIR/terraform.tfstate" ]; then
  echo "FAIL: State file not found. Run 'terraform apply' or import to recover state tracking."
  exit 1
fi
if ! grep -q 'local_file.app' "$DIR/terraform.tfstate"; then
  echo "FAIL: Resource local_file.app is not tracked in state."
  exit 1
fi
echo "PASS: State recovered and verified."
exit 0
