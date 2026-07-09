#!/bin/bash
# validator.sh — nginx-serving-content / 04-custom-error-pages / nginx-custom-404
set -euo pipefail

# Query a non-existent path and expect a 404 response containing our custom text
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/doesnotexist || true)

if ! echo "$RESPONSE" | grep -q "404 Not Found"; then
  echo "FAIL: Server did not return a 404 status code."
  exit 1
fi

if ! echo "$RESPONSE" | grep -q "Custom 404 - File Not Found"; then
  echo "FAIL: Server returned 404, but not the custom page content ('Custom 404 - File Not Found')."
  exit 1
fi

# Verify error_page is configured in config
if ! grep -q "error_page.*404.*/404.html" /etc/nginx/sites-available/default; then
  echo "FAIL: 'error_page 404 /404.html;' directive not found in configuration."
  exit 1
fi

echo "PASS: Custom 404 error page successfully configured."
exit 0
