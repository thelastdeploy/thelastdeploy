#!/bin/bash
# validator.sh — nginx-security-and-performance / 06-improve-production-performance / nginx-optimize-production-config
set -euo pipefail

# Verify worker_processes is set to auto
if ! grep -q "worker_processes[[:space:]]\+auto" /etc/nginx/nginx.conf; then
  echo "FAIL: 'worker_processes auto;' not found in /etc/nginx/nginx.conf."
  exit 1
fi

# Verify keepalive_timeout is reduced to 65
if ! grep -q "keepalive_timeout[[:space:]]\+65;" /etc/nginx/nginx.conf; then
  echo "FAIL: 'keepalive_timeout 65;' not found in /etc/nginx/nginx.conf."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Production configuration optimized successfully."
exit 0
