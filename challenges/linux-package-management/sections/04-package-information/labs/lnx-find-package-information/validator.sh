#!/bin/bash
# validator.sh — linux-package-management / 04-package-information / lnx-find-package-information
set -euo pipefail

FILE="$HOME/pkg-test/bash_owner.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'bash' to ~/pkg-test/bash_owner.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "bash" ] && [ "$CONTENT" != "base-files" ]; then
  echo "FAIL: Expected 'bash' or 'base-files' in ~/pkg-test/bash_owner.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Package ownership traced successfully."
exit 0
