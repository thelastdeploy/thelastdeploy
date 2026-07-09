#!/bin/bash
# validator.sh — nginx-security-and-performance / 02-security-headers / nginx-content-security-policy
set -euo pipefail

CONFIG="/etc/nginx/sites-available/default"

# Verify Content-Security-Policy is present
if ! grep -q "Content-Security-Policy" "$CONFIG"; then
  echo "FAIL: Content-Security-Policy header configuration not found in sites-available/default."
  exit 1
fi

if ! grep -q "default-src[[:space:]]\+['\"]self['\"]" "$CONFIG"; then
  echo "FAIL: CSP header does not restrict 'default-src' to 'self'."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Content-Security-Policy header configured successfully."
exit 0
