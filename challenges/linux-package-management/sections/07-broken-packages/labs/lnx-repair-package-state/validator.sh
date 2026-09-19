#!/bin/bash
# validator.sh — linux-package-management / 07-broken-packages / lnx-repair-package-state
set -euo pipefail

LOCK_FILE="$HOME/broken-test/lock_zone/dpkg_lock.lock"
if [ -f "$LOCK_FILE" ]; then
  echo "FAIL: Stale lock file $LOCK_FILE still exists. Remove the lock file to resolve package manager lock."
  exit 1
fi

echo "PASS: Stale package manager lock file cleared successfully!"
exit 0
