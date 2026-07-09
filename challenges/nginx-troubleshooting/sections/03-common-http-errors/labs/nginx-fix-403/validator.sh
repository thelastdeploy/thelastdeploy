#!/bin/bash
# validator.sh — nginx-troubleshooting / 03-common-http-errors / nginx-fix-403
set -euo pipefail

# Check if curl to localhost returns 200 OK
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)

if [ "$STATUS_CODE" != "200" ]; then
  echo "FAIL: Request to http://localhost/ returned HTTP $STATUS_CODE instead of 200."
  exit 1
fi

echo "PASS: 403 Forbidden error resolved successfully."
exit 0
