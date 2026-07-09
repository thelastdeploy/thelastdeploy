#!/bin/bash
# validator.sh — nginx-serving-content / 03-index-files / nginx-custom-index
set -euo pipefail

# Check if curl to localhost yields 'Custom welcome page' (indicating custom.html was selected first)
if ! curl -s --connect-timeout 2 http://localhost/ | grep -q "Custom welcome page"; then
  echo "FAIL: The default page served is not custom.html containing 'Custom welcome page'."
  exit 1
fi

# Confirm custom.html is configured first in default config
if ! grep -q "index[[:space:]]\+custom.html" /etc/nginx/sites-available/default; then
  echo "FAIL: 'custom.html' is not configured as the first option in the 'index' directive of /etc/nginx/sites-available/default."
  exit 1
fi

echo "PASS: Custom index prioritised and loaded successfully."
exit 0
