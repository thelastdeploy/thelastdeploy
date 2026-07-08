#!/bin/bash
# validator.sh — nginx-fundamentals / 04-installing-nginx / nginx-verify-installation
set -euo pipefail

# Check for Nginx config file directory
if [ ! -d "/etc/nginx" ] && [ ! -d "/usr/local/etc/nginx" ]; then
  echo "FAIL: Default Nginx configuration directory (/etc/nginx or /usr/local/etc/nginx) not found. Make sure Nginx is installed correctly."
  exit 1
fi

echo "PASS: Nginx configuration directory verified."
exit 0
