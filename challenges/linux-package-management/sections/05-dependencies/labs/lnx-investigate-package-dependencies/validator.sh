#!/bin/bash
# validator.sh — linux-package-management / 05-dependencies / lnx-investigate-package-dependencies
set -euo pipefail

FILE="$HOME/pkg-test/req_dep.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'libssl-dev' to ~/pkg-test/req_dep.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "libssl-dev" ]; then
  echo "FAIL: Expected 'libssl-dev' in ~/pkg-test/req_dep.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Package dependency investigated successfully."
exit 0
