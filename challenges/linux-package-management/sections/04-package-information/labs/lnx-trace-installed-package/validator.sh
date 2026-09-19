#!/bin/bash
# validator.sh — linux-package-management / 04-package-information / lnx-trace-installed-package
set -euo pipefail

FILE="$HOME/pkg-test/git_package.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'git' to ~/pkg-test/git_package.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "git" ]; then
  echo "FAIL: Expected 'git' in ~/pkg-test/git_package.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Installed package traced successfully."
exit 0
