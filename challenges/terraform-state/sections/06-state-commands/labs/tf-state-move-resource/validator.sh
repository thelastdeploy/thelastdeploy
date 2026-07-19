#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
STATE_LIST=$(terraform -chdir="$DIR" state list)
if echo "$STATE_LIST" | grep -q 'local_file.old_name'; then
  echo "FAIL: Resource 'local_file.old_name' is still present in state. Run 'terraform state mv local_file.old_name local_file.new_name'."
  exit 1
fi
if ! echo "$STATE_LIST" | grep -q 'local_file.new_name'; then
  echo "FAIL: Resource 'local_file.new_name' not found in state."
  exit 1
fi
echo "PASS: State resource renamed successfully using state mv."
exit 0
