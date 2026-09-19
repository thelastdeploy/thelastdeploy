#!/bin/bash
# validator.sh — linux-package-management / 02-installing-packages / lnx-install-package-from-repository
set -euo pipefail

FILE="$HOME/pkg-test/tar_status.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'installed' to ~/pkg-test/tar_status.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "installed" ]; then
  echo "FAIL: Expected 'installed' in ~/pkg-test/tar_status.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Repository package installation verified."
exit 0
