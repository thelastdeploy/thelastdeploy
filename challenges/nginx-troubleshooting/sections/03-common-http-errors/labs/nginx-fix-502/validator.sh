#!/bin/bash
# validator.sh — nginx-troubleshooting / 03-common-http-errors / nginx-fix-502
set -euo pipefail

# Curl http://localhost/api and verify it contains "API OK"
RESPONSE=$(curl -s http://localhost/api)

if [ "$RESPONSE" != "API OK" ]; then
  echo "FAIL: Expected 'API OK' response from http://localhost/api but got '$RESPONSE'."
  exit 1
fi

CONFIG="/etc/nginx/sites-available/default"

# Verify proxy_pass points to 8080
if ! grep -A 5 "location.*/api" "$CONFIG" | grep -q "proxy_pass[[:space:]]\+http://127.0.0.1:8080"; then
  echo "FAIL: Proxy pass destination inside /api is not set to http://127.0.0.1:8080."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: 502 Bad Gateway error resolved successfully."
exit 0
