#!/bin/bash
# validator.sh — nginx-reverse-proxy / 03-forwarding-headers / nginx-forward-host-header
set -euo pipefail

CONFIG="/etc/nginx/sites-available/default"

# Verify location /node block contains proxy_set_header Host $host (or $http_host)
if ! grep -A 5 "location.*/node" "$CONFIG" | grep -q "proxy_set_header[[:space:]]\+Host[[:space:]]\+\$host"; then
  if ! grep -A 5 "location.*/node" "$CONFIG" | grep -q "proxy_set_header[[:space:]]\+Host[[:space:]]\+\$http_host"; then
    echo "FAIL: Location /node block is missing Host header forwarding configuration."
    exit 1
  fi
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Host header forwarding configured successfully."
exit 0
