#!/bin/bash
# validator.sh — nginx-configuration / 03-server-blocks / nginx-create-server-block
set -euo pipefail

FILE="/etc/nginx/sites-available/mysite"
if [ ! -f "$FILE" ] && [ -f "$FILE.conf" ]; then
  FILE="$FILE.conf"
fi

if [ ! -f "$FILE" ]; then
  echo "FAIL: Configuration file 'mysite' (or 'mysite.conf') not found in /etc/nginx/sites-available/"
  exit 1
fi

# Clean comments and parse properties
CONTENT=$(grep -v '^[[:space:]]*#' "$FILE")

if ! echo "$CONTENT" | grep -q "listen[[:space:]]\+8080"; then
  echo "FAIL: Configuration does not contain 'listen 8080;' directive."
  exit 1
fi

if ! echo "$CONTENT" | grep -q "server_name[[:space:]]\+mysite.local"; then
  echo "FAIL: Configuration does not contain 'server_name mysite.local;' directive."
  exit 1
fi

if ! echo "$CONTENT" | grep -q "root[[:space:]]\+/var/www/mysite"; then
  echo "FAIL: Configuration does not contain 'root /var/www/mysite;' directive."
  exit 1
fi

echo "PASS: Server block 'mysite' correctly created and configured."
exit 0
