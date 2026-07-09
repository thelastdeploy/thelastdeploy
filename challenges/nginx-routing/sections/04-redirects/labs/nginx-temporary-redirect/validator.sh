#!/bin/bash
# validator.sh — nginx-routing / 04-redirects / nginx-temporary-redirect
set -euo pipefail

# Query /promo and check if it temporarily redirects to /landing-page
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/promo || true)

if ! echo "$RESPONSE" | grep -q "302 Found" && ! echo "$RESPONSE" | grep -q "302 Moved Temporarily"; then
  echo "FAIL: Request did not return 302 Found/Temporary redirect status code."
  exit 1
fi

if ! echo "$RESPONSE" | grep -i -q "Location: http://localhost/landing-page" && ! echo "$RESPONSE" | grep -i -q "Location: /landing-page"; then
  echo "FAIL: Redirection target Location is not pointing to /landing-page."
  exit 1
fi

echo "PASS: Temporary redirect configured successfully."
exit 0
