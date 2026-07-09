#!/bin/bash
# validator.sh — nginx-troubleshooting / 03-common-http-errors / nginx-fix-404
set -euo pipefail

# Check if curl to localhost returns 200 OK
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)

if [ "$STATUS_CODE" != "200" ]; then
  echo "FAIL: Request to http://localhost/ returned HTTP $STATUS_CODE instead of 200."
  exit 1
fi

# Verify root directive in config
CONFIG="/etc/nginx/sites-available/default"
if ! grep -q "root[[:space:]]\+/var/www/html;" "$CONFIG"; then
  echo "FAIL: The root directive in sites-available/default is still incorrect."
  exit 1
fi

echo "PASS: 404 Not Found error resolved successfully."
exit 0
