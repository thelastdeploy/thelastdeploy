#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-state-challenge"
if [ ! -f "/tmp/recovery.txt" ]; then
  echo "FAIL: Target file /tmp/recovery.txt is missing. Run 'terraform apply' to restore drifted infrastructure."
  exit 1
fi
CONTENT=$(cat /tmp/recovery.txt)
if [ "$CONTENT" != "expected_state" ]; then
  echo "FAIL: Content of /tmp/recovery.txt is '$CONTENT', expected 'expected_state'."
  exit 1
fi
echo "PASS: State drift recovered and infrastructure restored successfully."
exit 0
