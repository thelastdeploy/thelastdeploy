#!/bin/bash
# validator.sh — nginx-routing / 03-rewrites / nginx-basic-rewrite
set -euo pipefail

# Query oldpath and ensure it returns newpath content with 200 OK
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/oldpath/file.html || true)

if ! echo "$RESPONSE" | grep -q "200 OK"; then
  echo "FAIL: Request did not return 200 OK (got external redirect or error)."
  exit 1
fi

if ! echo "$RESPONSE" | grep -q "new content"; then
  echo "FAIL: Request to /oldpath/file.html did not return rewritten content ('new content')."
  exit 1
fi

# Ensure rewrite configuration exists
if ! grep -q "rewrite.*oldpath.*newpath" /etc/nginx/sites-available/default; then
  echo "FAIL: No rewrite rule matching '/oldpath/' and mapping to '/newpath/' found in /etc/nginx/sites-available/default."
  exit 1
fi

echo "PASS: Basic internal rewrite configured successfully."
exit 0
