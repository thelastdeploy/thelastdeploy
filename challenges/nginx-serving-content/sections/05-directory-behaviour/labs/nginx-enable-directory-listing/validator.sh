#!/bin/bash
# validator.sh — nginx-serving-content / 05-directory-behaviour / nginx-enable-directory-listing
set -euo pipefail

# Query downloads/ path and check for autoindex directory listing
RESPONSE=$(curl -s --connect-timeout 2 http://localhost/downloads/)

if ! echo "$RESPONSE" | grep -q "Index of /downloads/"; then
  echo "FAIL: Accessing /downloads/ did not return directory index listing."
  exit 1
fi

if ! echo "$RESPONSE" | grep -q "pkg1.tar.gz"; then
  echo "FAIL: Directory index listing does not contain 'pkg1.tar.gz'."
  exit 1
fi

echo "PASS: Directory listing enabled for /downloads/ successfully."
exit 0
