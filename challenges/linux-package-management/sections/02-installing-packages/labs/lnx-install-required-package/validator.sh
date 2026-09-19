#!/bin/bash
# validator.sh — linux-package-management / 02-installing-packages / lnx-install-required-package
set -euo pipefail

FILE="$HOME/pkg-test/curl_path.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Run 'which curl > ~/pkg-test/curl_path.txt'."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
EXPECTED=$(which curl 2>/dev/null || echo "/usr/bin/curl")

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "FAIL: Expected '$EXPECTED' in ~/pkg-test/curl_path.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Required package path verified."
exit 0
