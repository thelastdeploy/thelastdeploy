#!/bin/bash
# validator.sh — nginx-security-and-performance / 04-compression / nginx-enable-gzip
set -euo pipefail

# Verify gzip is enabled globally in nginx.conf
if ! grep -q "gzip[[:space:]]\+on" /etc/nginx/nginx.conf; then
  echo "FAIL: 'gzip on;' not found in /etc/nginx/nginx.conf."
  exit 1
fi

# Verify gzip_types contains text/css
if ! grep -q "gzip_types.*text/css" /etc/nginx/nginx.conf; then
  echo "FAIL: 'gzip_types' does not include 'text/css' in /etc/nginx/nginx.conf."
  exit 1
fi

# Verify gzip_types contains application/json
if ! grep -q "gzip_types.*application/json" /etc/nginx/nginx.conf; then
  echo "FAIL: 'gzip_types' does not include 'application/json' in /etc/nginx/nginx.conf."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Gzip compression configured successfully."
exit 0
