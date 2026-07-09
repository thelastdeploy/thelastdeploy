#!/bin/bash
# validator.sh — nginx-reverse-proxy / 03-forwarding-headers / nginx-forward-client-ip
set -euo pipefail

CONFIG="/etc/nginx/sites-available/default"

# Verify X-Real-IP is forwarded
if ! grep -A 7 "location.*/node" "$CONFIG" | grep -q "proxy_set_header[[:space:]]\+X-Real-IP[[:space:]]\+\$remote_addr"; then
  echo "FAIL: Location /node block is missing X-Real-IP forwarding configuration using '\$remote_addr'."
  exit 1
fi

# Verify X-Forwarded-For is forwarded
if ! grep -A 7 "location.*/node" "$CONFIG" | grep -q "proxy_set_header[[:space:]]\+X-Forwarded-For[[:space:]]\+\$proxy_add_x_forwarded_for"; then
  echo "FAIL: Location /node block is missing X-Forwarded-For forwarding configuration using '\$proxy_add_x_forwarded_for'."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Client IP forwarding headers configured successfully."
exit 0
