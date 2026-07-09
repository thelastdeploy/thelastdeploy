#!/bin/bash
# validator.sh — nginx-routing / 02-location-matching / nginx-prefix-match
set -euo pipefail

# Curl http://localhost/docs/ should return 'prefix test'
if ! curl -s --connect-timeout 2 http://localhost/docs/ | grep -q "prefix test"; then
  echo "FAIL: Prefix match is not serving content correctly at http://localhost/docs/"
  exit 1
fi

# Verify location prefix blocks are configured
if ! grep -q "location.*/docs" /etc/nginx/sites-available/default; then
  echo "FAIL: Location /docs not configured in /etc/nginx/sites-available/default."
  exit 1
fi

echo "PASS: Prefix match location configured correctly."
exit 0
