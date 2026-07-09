#!/bin/bash
# validator.sh — nginx-security-and-performance / 05-basic-caching / nginx-enable-cache
set -euo pipefail

# Verify proxy_cache_path keys_zone is defined in nginx.conf
if ! grep -q "proxy_cache_path.*keys_zone=my_cache:10m" /etc/nginx/nginx.conf; then
  echo "FAIL: 'proxy_cache_path' directive with keys_zone=my_cache:10m not found in /etc/nginx/nginx.conf."
  exit 1
fi

if ! grep -q "inactive=60m" /etc/nginx/nginx.conf; then
  echo "FAIL: 'inactive=60m' parameter is missing or incorrect in proxy_cache_path."
  exit 1
fi

CONFIG="/etc/nginx/sites-available/default"

# Verify proxy_cache is applied inside /app location
if ! grep -A 5 "location.*/app" "$CONFIG" | grep -q "proxy_cache[[:space:]]\+my_cache"; then
  echo "FAIL: location block /app is missing 'proxy_cache my_cache;' directive."
  exit 1
fi

# Verify proxy_cache_valid 200 10m
if ! grep -A 5 "location.*/app" "$CONFIG" | grep -q "proxy_cache_valid[[:space:]]\+200[[:space:]]\+10m"; then
  echo "FAIL: location block /app is missing or has incorrect 'proxy_cache_valid 200 10m;' configuration."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Proxy caching configured successfully."
exit 0
