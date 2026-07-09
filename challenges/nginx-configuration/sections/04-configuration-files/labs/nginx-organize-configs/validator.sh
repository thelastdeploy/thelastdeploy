#!/bin/bash
# validator.sh — nginx-configuration / 04-configuration-files / nginx-organize-configs
set -euo pipefail

FILE="/etc/nginx/conf.d/upstream.conf"
if [ ! -f "$FILE" ]; then
  echo "FAIL: Configuration file 'upstream.conf' not found in /etc/nginx/conf.d/"
  exit 1
fi

# Ensure Nginx config syntax is correct
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed. Please verify your custom config file format."
  exit 1
fi

echo "PASS: Configuration organized correctly under conf.d."
exit 0
