#!/bin/bash
# validator.sh — nginx-routing / 04-redirects / nginx-permanent-redirect
set -euo pipefail

# Query /old-page and check if it permanently redirects to /new-page
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/old-page || true)

if ! echo "$RESPONSE" | grep -q "301 Moved Permanently"; then
  echo "FAIL: Request did not return 301 Moved Permanently."
  exit 1
fi

if ! echo "$RESPONSE" | grep -i -q "Location: http://localhost/new-page" && ! echo "$RESPONSE" | grep -i -q "Location: /new-page"; then
  echo "FAIL: Redirection target Location is not pointing to /new-page."
  exit 1
fi

echo "PASS: Permanent redirect configured successfully."
exit 0
