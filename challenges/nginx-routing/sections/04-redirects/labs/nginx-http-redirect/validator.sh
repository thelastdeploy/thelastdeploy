#!/bin/bash
# validator.sh — nginx-routing / 04-redirects / nginx-http-redirect
set -euo pipefail

# Query /google and check if it redirects to google.com
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/google || true)

if ! echo "$RESPONSE" | grep -q "302 Found" && ! echo "$RESPONSE" | grep -q "302 Moved Temporarily"; then
  echo "FAIL: Request to /google did not return a 302 redirection status code."
  exit 1
fi

if ! echo "$RESPONSE" | grep -i -q "Location: https://www.google.com"; then
  echo "FAIL: Location redirect header is not pointing to https://www.google.com."
  exit 1
fi

echo "PASS: HTTP redirect configured successfully."
exit 0
