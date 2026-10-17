#!/bin/bash
set -euo pipefail

if [ ! -f /tmp/found_root_cause ]; then
  echo "FAIL: /tmp/found_root_cause marker file not found. Run: touch /tmp/found_root_cause"
  exit 1
fi

if [ ! -e /var/log/app-server.log ]; then
  echo "FAIL: /var/log/app-server.log does not exist."
  exit 1
fi

PERMS=$(stat -c "%a" /var/log/app-server.log 2>/dev/null || echo "000")
if [ "$PERMS" != "000" ] && [ "$PERMS" != "0" ]; then
  echo "FAIL: Log file permissions should still be broken (000) during root cause identification."
  exit 1
fi

echo "PASS: Root cause identified successfully."
exit 0
