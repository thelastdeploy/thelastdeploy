#!/bin/bash
# validator.sh — nginx-serving-content / 06-repair-a-static-site / nginx-static-site-not-working
set -euo pipefail

# Check if accessing index yields 200 OK
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/ || true)

if ! echo "$RESPONSE" | grep -q "200 OK"; then
  echo "FAIL: Server is still not able to serve the welcome page. (Got: $(echo "$RESPONSE" | head -n 1))"
  exit 1
fi

echo "PASS: Directory permissions fixed and static welcome page successfully served."
exit 0
