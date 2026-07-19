#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
if ! terraform -chdir="$DIR" state show local_file.secret &>/dev/null; then
  echo "FAIL: Failed to inspect state for local_file.secret."
  exit 1
fi
echo "PASS: State inspection verified."
exit 0
