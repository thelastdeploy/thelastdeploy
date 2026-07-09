#!/bin/bash
# validator.sh — nginx-routing / 03-rewrites / nginx-pretty-url
set -euo pipefail

# Query products/123 and ensure it returns product.html contents
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/products/123 || true)

if ! echo "$RESPONSE" | grep -q "200 OK"; then
  echo "FAIL: Request did not return 200 OK."
  exit 1
fi

if ! echo "$RESPONSE" | grep -q "product page"; then
  echo "FAIL: Request to /products/123 did not return product.html page."
  exit 1
fi

# Ensure rewrite configuration exists
if ! grep -q "rewrite.*products.*product\.html" /etc/nginx/sites-available/default; then
  echo "FAIL: Rewrite rule mapping '/products/' regex to '/product.html' not found in config."
  exit 1
fi

echo "PASS: Pretty URL rewrite configured successfully."
exit 0
