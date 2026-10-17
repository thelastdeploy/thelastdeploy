#!/bin/bash
set -euo pipefail

if [ ! -f /tmp/checked_logs ]; then
  echo "FAIL: /tmp/checked_logs marker file not found. Run: touch /tmp/checked_logs"
  exit 1
fi

if [ ! -e /var/log/app-server.log ]; then
  echo "FAIL: /var/log/app-server.log does not exist."
  exit 1
fi

PERMS=$(stat -c "%a" /var/log/app-server.log 2>/dev/null || echo "000")
if [ "$PERMS" != "000" ] && [ "$PERMS" != "0" ]; then
  echo "FAIL: /var/log/app-server.log should have broken (non-readable) permissions for this initial investigation lab."
  exit 1
fi

echo "PASS: Investigated broken log permissions successfully."
exit 0
