#!/bin/bash
# validator.sh — nginx-reverse-proxy / 02-proxy-pass / nginx-proxy-node-app
set -euo pipefail

# Ensure location /node is configured with proxy_pass http://127.0.0.1:3000
CONFIG="/etc/nginx/sites-available/default"

if ! grep -q "location.*/node" "$CONFIG"; then
  echo "FAIL: location block for /node not found in default configuration."
  exit 1
fi

# Extract the lines matching location block and ensure proxy_pass is inside
# Since we just need to verify config format
if ! grep -A 5 "location.*/node" "$CONFIG" | grep -q "proxy_pass[[:space:]]\+http://127.0.0.1:3000"; then
  echo "FAIL: Location /node is not proxying to http://127.0.0.1:3000."
  exit 1
fi

# Check syntax check succeeds
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Node app proxy pass configured successfully."
exit 0
