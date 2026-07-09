#!/bin/bash
# validator.sh — nginx-routing / 06-debug-routing-problems / nginx-fix-routing
set -euo pipefail

# Query /documents/report.pdf and verify it returns 'docs report' (indicating the prefix block overrode the regex block)
RESPONSE=$(curl -s --connect-timeout 2 http://localhost/documents/report.pdf)

if ! echo "$RESPONSE" | grep -q "docs report"; then
  echo "FAIL: Query to /documents/report.pdf returned: '$RESPONSE' instead of 'docs report'."
  exit 1
fi

# Ensure that the priority modifier ^~ is used in sites-available/default
if ! grep -q "location[[:space:]]\+\^\~[[:space:]]\+/documents/" /etc/nginx/sites-available/default; then
  echo "FAIL: The location block /documents/ does not use the priority modifier '^~'."
  exit 1
fi

echo "PASS: Routing conflict fixed successfully."
exit 0
