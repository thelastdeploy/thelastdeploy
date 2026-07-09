#!/bin/bash
# validator.sh — nginx-serving-content / 05-directory-behaviour / nginx-disable-directory-listing
set -euo pipefail

# Accessing http://localhost/secret/ should return 403 Forbidden
RESPONSE=$(curl -i -s --connect-timeout 2 http://localhost/secret/ || true)

if ! echo "$RESPONSE" | grep -q "403 Forbidden"; then
  echo "FAIL: Accessing /secret/ did not return 403 Forbidden status code. Directory listing might be enabled."
  exit 1
fi

echo "PASS: Directory listing for /secret/ is disabled."
exit 0
