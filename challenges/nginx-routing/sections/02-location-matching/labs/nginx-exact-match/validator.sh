#!/bin/bash
# validator.sh — nginx-routing / 02-location-matching / nginx-exact-match
set -euo pipefail

# Curl http://localhost/special.html should return 'exact test'
if ! curl -s --connect-timeout 2 http://localhost/special.html | grep -q "exact test"; then
  echo "FAIL: Exact match location is not serving content correctly at http://localhost/special.html"
  exit 1
fi

# Verify exact match modifier '=' is used in configuration
if ! grep -q "location[[:space:]]\+=[[:space:]]\+/special.html" /etc/nginx/sites-available/default; then
  echo "FAIL: Exact match modifier '=' was not found for location /special.html in sites-available/default."
  exit 1
fi

echo "PASS: Exact match location configured correctly."
exit 0
