#!/bin/bash
# validator.sh — nginx-troubleshooting / 03-common-http-errors / nginx-fix-500
set -euo pipefail

# Check if curl to /loop returns 200 OK or is redirected/handled without internal 500 error
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/loop)

if [ "$STATUS_CODE" == "500" ]; then
  echo "FAIL: Request to http://localhost/loop returned HTTP 500 (rewrite loop still active)."
  exit 1
fi

CONFIG="/etc/nginx/sites-available/default"

# Verify rewrite loop is removed
if grep -A 5 "location.*/loop" "$CONFIG" | grep -q "rewrite"; then
  echo "FAIL: Rewrite rules still present inside /loop location block in sites-available/default."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: 500 Internal Server Error (rewrite loop) resolved successfully."
exit 0
