#!/bin/bash
# validator.sh — nginx-serving-content / 02-root-vs-alias / nginx-root-directive
set -euo pipefail

# Check if curl to localhost/images/test.txt yields 'root test'
if ! curl -s --connect-timeout 2 http://localhost/images/test.txt | grep -q "root test"; then
  echo "FAIL: Root directive is not serving files correctly at http://localhost/images/test.txt"
  exit 1
fi

# Confirm root is configured for images in default site
if ! grep -q "location.*/images/" /etc/nginx/sites-available/default; then
  echo "FAIL: Could not locate '/images/' location block in default site configuration."
  exit 1
fi

echo "PASS: Location /images/ root path configured correctly."
exit 0
