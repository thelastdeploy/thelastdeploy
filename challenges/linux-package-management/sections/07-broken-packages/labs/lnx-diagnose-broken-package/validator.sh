#!/bin/bash
# validator.sh — linux-package-management / 07-broken-packages / lnx-diagnose-broken-package
set -euo pipefail

FILE="$HOME/broken-test/broken_package.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'custom-app' to ~/broken-test/broken_package.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "custom-app" ]; then
  echo "FAIL: Expected 'custom-app' in ~/broken-test/broken_package.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Broken package status diagnosed successfully."
exit 0
