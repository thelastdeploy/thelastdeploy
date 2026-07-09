#!/bin/bash
# validator.sh — nginx-security-and-performance / 02-security-headers / nginx-enable-hsts
set -euo pipefail

CONFIG="/etc/nginx/sites-available/default"

# Verify Strict-Transport-Security exists in config
if ! grep -q "Strict-Transport-Security" "$CONFIG"; then
  echo "FAIL: Strict-Transport-Security header configuration not found in /etc/nginx/sites-available/default."
  exit 1
fi

if ! grep -q "max-age=31536000" "$CONFIG"; then
  echo "FAIL: HSTS header does not define 'max-age=31536000'."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: HSTS security header configured successfully."
exit 0
