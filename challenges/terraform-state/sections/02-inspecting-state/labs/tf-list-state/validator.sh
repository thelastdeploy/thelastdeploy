#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
OUTPUT=$(terraform -chdir="$DIR" state list)
if ! echo "$OUTPUT" | grep -q 'local_file.f1' || ! echo "$OUTPUT" | grep -q 'local_file.f2'; then
  echo "FAIL: State list does not contain expected resources local_file.f1 and local_file.f2."
  exit 1
fi
echo "PASS: State listing verified."
exit 0
