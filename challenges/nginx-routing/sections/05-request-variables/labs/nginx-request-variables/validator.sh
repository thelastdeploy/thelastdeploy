#!/bin/bash
# validator.sh — nginx-routing / 05-request-variables / nginx-request-variables
set -euo pipefail

# Query /info using a custom user agent string and check if it gets echoed back
UA="TestUserAgent123"
RESPONSE=$(curl -s -H "User-Agent: $UA" http://localhost/info)

if ! echo "$RESPONSE" | grep -q "Agent: $UA"; then
  echo "FAIL: Querying /info did not return user agent echo. Expected: 'Agent: $UA' (got: '$RESPONSE')"
  exit 1
fi

echo "PASS: Nginx variable interpolation configured successfully."
exit 0
