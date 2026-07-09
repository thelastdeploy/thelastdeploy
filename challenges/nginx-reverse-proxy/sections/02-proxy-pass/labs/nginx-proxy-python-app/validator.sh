#!/bin/bash
# validator.sh — nginx-reverse-proxy / 02-proxy-pass / nginx-proxy-python-app
set -euo pipefail

# Ensure location /python is configured with proxy_pass http://127.0.0.1:8000
CONFIG="/etc/nginx/sites-available/default"

if ! grep -q "location.*/python" "$CONFIG"; then
  echo "FAIL: location block for /python not found in default configuration."
  exit 1
fi

if ! grep -A 5 "location.*/python" "$CONFIG" | grep -q "proxy_pass[[:space:]]\+http://127.0.0.1:8000"; then
  echo "FAIL: Location /python is not proxying to http://127.0.0.1:8000."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Python app proxy pass configured successfully."
exit 0
