#!/bin/bash
# validator.sh — nginx-security-and-performance / 02-security-headers / nginx-x-frame-options
set -euo pipefail

CONFIG="/etc/nginx/sites-available/default"

# Verify X-Frame-Options exists and is DENY
if ! grep -q "X-Frame-Options" "$CONFIG"; then
  echo "FAIL: X-Frame-Options header configuration not found in sites-available/default."
  exit 1
fi

if ! grep -i -q "X-Frame-Options.*[‘“'\"\ ]DENY" "$CONFIG"; then
  echo "FAIL: X-Frame-Options value is not set to 'DENY'."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: X-Frame-Options header configured successfully."
exit 0
