#!/bin/bash
# validator.sh — linux-package-management / 01-package-management-basics / lnx-identify-package-manager
set -euo pipefail

FILE="$HOME/pkg-test/pkg_manager.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'apt' or 'dnf' to ~/pkg-test/pkg_manager.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
EXPECTED="apt"
if command -v dnf &>/dev/null; then
  EXPECTED="dnf"
fi

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "FAIL: Expected '$EXPECTED' in ~/pkg-test/pkg_manager.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Active package manager identified successfully."
exit 0
