#!/bin/bash
# validator.sh — linux-package-management / 01-package-management-basics / lnx-inspect-installed-packages
set -euo pipefail

FILE="$HOME/pkg-test/bash_status.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'installed' to ~/pkg-test/bash_status.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "installed" ]; then
  echo "FAIL: Expected 'installed' in ~/pkg-test/bash_status.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Installed package status queried successfully."
exit 0
