#!/bin/bash
# validator.sh — nginx-reverse-proxy / 04-upstream-blocks / nginx-load-balance-two-backends
set -euo pipefail

# Ensure location /app is proxying to http://backend_servers
CONFIG="/etc/nginx/sites-available/default"

if ! grep -q "location.*/app" "$CONFIG"; then
  echo "FAIL: location block /app not found in sites-available/default."
  exit 1
fi

if ! grep -A 5 "location.*/app" "$CONFIG" | grep -q "proxy_pass[[:space:]]\+http://backend_servers"; then
  echo "FAIL: location block /app is not proxying to upstream pool http://backend_servers."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration check is failing."
  exit 1
fi

echo "PASS: Load balancing reverse proxy configured successfully."
exit 0
