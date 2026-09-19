#!/bin/bash
# validator.sh — linux-package-management / 06-repositories / lnx-investigate-package-repositories
set -euo pipefail

FILE="$HOME/repo-test/repo_codename.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File $FILE not found. Save 'focal' to ~/repo-test/repo_codename.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)
if [ "$CONTENT" != "focal" ]; then
  echo "FAIL: Expected 'focal' in ~/repo-test/repo_codename.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Repository codename verified successfully."
exit 0
