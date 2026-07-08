#!/bin/bash
# validator.sh — nginx-fundamentals / 06-exploring-the-default-site / nginx-default-page
set -euo pipefail

HTML_FILE="/var/www/html/index.html"
if [ ! -f "$HTML_FILE" ]; then
  echo "FAIL: Default index page not found at $HTML_FILE"
  exit 1
fi

if ! grep -q -i "Hello from The Last Deploy" "$HTML_FILE"; then
  echo "FAIL: The default welcome page does not contain 'Hello from The Last Deploy'."
  exit 1
fi

# Try checking HTTP request to localhost:80
if curl -s http://localhost/ | grep -q -i "Hello from The Last Deploy"; then
  echo "PASS: Default page successfully modified and served by Nginx."
  exit 0
else
  # Fallback: maybe they modified the file but Nginx is stopped
  echo "FAIL: File is modified, but Nginx is not serving the modified page at http://localhost/. Is Nginx started?"
  exit 1
fi
