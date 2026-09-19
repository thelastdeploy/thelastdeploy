#!/bin/bash
# validator.sh — linux-package-management / 03-updating-and-removing / lnx-manage-outdated-packages
set -euo pipefail

FILE="$HOME/pkg-test/upgradable_count.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save '3' to ~/pkg-test/upgradable_count.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "3" ]; then
  echo "FAIL: Expected '3' in ~/pkg-test/upgradable_count.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Upgradable package count verified."
exit 0
