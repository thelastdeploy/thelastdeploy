#!/bin/bash
# validator.sh — nginx-routing / 02-location-matching / nginx-regex-match
set -euo pipefail

# Query a PNG image with mixed case extension (.PNG)
if ! curl -s --connect-timeout 2 http://localhost/test.PNG | grep -q "regex test"; then
  echo "FAIL: Case-insensitive regex match is not serving the PNG file correctly."
  exit 1
fi

# Ensure case-insensitive regex modifier '~*' is present in default config
if ! grep -q "location[[:space:]]\+\~\*[[:space:]]" /etc/nginx/sites-available/default; then
  echo "FAIL: Case-insensitive regex location modifier '~*' not found in configuration."
  exit 1
fi

echo "PASS: Regex location match configured correctly."
exit 0
