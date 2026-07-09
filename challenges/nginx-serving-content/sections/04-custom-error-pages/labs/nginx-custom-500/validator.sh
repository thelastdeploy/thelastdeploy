#!/bin/bash
# validator.sh — nginx-serving-content / 04-custom-error-pages / nginx-custom-500
set -euo pipefail

# Check if 50x.html exists and contains the string
FILE="/var/www/html/50x.html"
if [ ! -f "$FILE" ]; then
  echo "FAIL: Custom error page file /var/www/html/50x.html not found."
  exit 1
fi

if ! grep -q "Custom 50x - Server Error" "$FILE"; then
  echo "FAIL: Custom 50x error page content does not match 'Custom 50x - Server Error'."
  exit 1
fi

# Verify error_page is configured in config for 500, 502, 503, 504
CONFIG="/etc/nginx/sites-available/default"
if ! grep -q "error_page.*500.*502.*503.*504.*/50x.html" "$CONFIG"; then
  echo "FAIL: 'error_page 500 502 503 504 /50x.html;' directive not found in configuration."
  exit 1
fi

# Ensure syntax check passes
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test is failing. Please fix syntax errors."
  exit 1
fi

echo "PASS: Custom 50x error pages successfully configured."
exit 0
