#!/bin/bash
# validator.sh — nginx-reverse-proxy / 06-recover-a-broken-proxy / nginx-fix-reverse-proxy
set -euo pipefail

# Ensure config test passes
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test is still failing. Check for 'invalid URL prefix'."
  exit 1
fi

CONFIG="/etc/nginx/sites-available/default"

# Verify proxy_pass contains http://
if ! grep -A 5 "location.*/api" "$CONFIG" | grep -q "proxy_pass[[:space:]]\+http://127.0.0.1:8080"; then
  echo "FAIL: The location block for /api is still missing 'http://' protocol scheme prefix."
  exit 1
fi

echo "PASS: Reverse proxy URL syntax error fixed successfully."
exit 0
