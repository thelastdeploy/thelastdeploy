#!/bin/bash
# validator.sh — nginx-troubleshooting / 06-recover-a-production-nginx-server / nginx-production-outage
set -euo pipefail

# Verify Nginx config passes tests
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

# Verify Nginx service is running
if ! systemctl is-active --quiet nginx; then
  echo "FAIL: Nginx service is not active."
  exit 1
fi

CONFIG="/etc/nginx/sites-available/default"

# Verify duplicate default_server is removed
DUPLICATE_COUNT=$(grep -o "listen.*default_server" "$CONFIG" | wc -l)
if [ "$DUPLICATE_COUNT" -gt 1 ]; then
  echo "FAIL: Multiple server blocks still have 'default_server' active."
  exit 1
fi

# Verify proxy_pass scheme has been fixed
if grep -q "proxy_pass ht://" "$CONFIG"; then
  echo "FAIL: The proxy_pass directive still has an invalid scheme 'ht://'."
  exit 1
fi

echo "PASS: Production outage recovered successfully."
exit 0
