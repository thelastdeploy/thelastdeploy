#!/bin/bash
# validator.sh — linux-package-management / 08-package-management-challenge / lnx-recover-broken-environment
set -euo pipefail

LOCK_FILE="$HOME/pkg-challenge/locks/frontend.lock"
if [ -f "$LOCK_FILE" ]; then
  echo "FAIL: Stale lock file $LOCK_FILE still exists. Remove the lock file."
  exit 1
fi

RESULT_FILE="$HOME/pkg-challenge/recovered_package.txt"
if [ ! -f "$RESULT_FILE" ]; then
  echo "FAIL: File $RESULT_FILE not found. Save 'app-service' to ~/pkg-challenge/recovered_package.txt."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$RESULT_FILE" | xargs)
if [ "$CONTENT" != "app-service" ]; then
  echo "FAIL: Expected 'app-service' in ~/pkg-challenge/recovered_package.txt, but got '$CONTENT'."
  exit 1
fi

echo "PASS: Package environment recovered successfully!"
exit 0
