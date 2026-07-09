#!/bin/bash
# validator.sh — nginx-serving-content / 02-root-vs-alias / nginx-alias-directive
set -euo pipefail

# Check if curl to localhost/assets/test.txt yields 'alias test'
if ! curl -s --connect-timeout 2 http://localhost/assets/test.txt | grep -q "alias test"; then
  echo "FAIL: Alias directive is not serving files correctly at http://localhost/assets/test.txt"
  exit 1
fi

# Confirm alias is configured in default site
if ! grep -q "location.*/assets/" /etc/nginx/sites-available/default; then
  echo "FAIL: Could not locate '/assets/' location block in default site configuration."
  exit 1
fi

echo "PASS: Location /assets/ alias path configured correctly."
exit 0
