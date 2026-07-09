#!/bin/bash
# validator.sh — nginx-reverse-proxy / 05-websocket-support / nginx-enable-websocket-proxy
set -euo pipefail

CONFIG="/etc/nginx/sites-available/default"

# Ensure location /ws is configured
if ! grep -q "location.*/ws" "$CONFIG"; then
  echo "FAIL: location block /ws not found in default configuration."
  exit 1
fi

# Ensure proxy_pass targets port 9000
if ! grep -A 8 "location.*/ws" "$CONFIG" | grep -q "proxy_pass[[:space:]]\+http://127.0.0.1:9000"; then
  echo "FAIL: location block /ws is not proxying to http://127.0.0.1:9000."
  exit 1
fi

# Ensure proxy_http_version 1.1 is active
if ! grep -A 8 "location.*/ws" "$CONFIG" | grep -q "proxy_http_version[[:space:]]\+1.1"; then
  echo "FAIL: 'proxy_http_version 1.1;' is not configured inside location /ws."
  exit 1
fi

# Ensure Upgrade header is mapped
if ! grep -A 8 "location.*/ws" "$CONFIG" | grep -q "proxy_set_header[[:space:]]\+Upgrade[[:space:]]\+\$http_upgrade"; then
  echo "FAIL: 'proxy_set_header Upgrade \$http_upgrade;' is not configured inside location /ws."
  exit 1
fi

# Ensure Connection header is mapped to upgrade
if ! grep -A 8 "location.*/ws" "$CONFIG" | grep -q "proxy_set_header[[:space:]]\+Connection[[:space:]]\+[\"']\?[Uu]pgrade[\"']\?"; then
  echo "FAIL: 'proxy_set_header Connection \"upgrade\";' is not configured inside location /ws."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration check is failing."
  exit 1
fi

echo "PASS: WebSocket connection upgrade proxying configured successfully."
exit 0
