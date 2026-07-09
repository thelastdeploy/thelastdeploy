#!/bin/bash
# validator.sh — nginx-configuration / 04-configuration-files / nginx-include-config
set -euo pipefail

# Check if the snippet file is referenced inside main config or default site config
if ! grep -r -q "include[[:space:]]\+snippets/custom-headers.conf" /etc/nginx/nginx.conf /etc/nginx/sites-available/ /etc/nginx/conf.d/ &>/dev/null; then
  if ! grep -r -q "include[[:space:]]\+/etc/nginx/snippets/custom-headers.conf" /etc/nginx/nginx.conf /etc/nginx/sites-available/ /etc/nginx/conf.d/ &>/dev/null; then
    echo "FAIL: No 'include snippets/custom-headers.conf;' directive found in your Nginx configuration files."
    exit 1
  fi
fi

# Ensure Nginx config syntax is correct
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test is failing. Please fix syntax errors."
  exit 1
fi

echo "PASS: Configuration snippet successfully included."
exit 0
