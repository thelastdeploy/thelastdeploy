#!/bin/bash
# validator.sh — nginx-fundamentals / 05-running-and-managing-nginx / nginx-reload-service
set -euo pipefail

# Make sure it's active
if ! systemctl is-active nginx &>/dev/null; then
  echo "FAIL: Nginx service is not running. Please make sure Nginx is running and then reload it."
  exit 1
fi

# Let's check if the service is active and configuration syntax is correct.
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed. Please verify your configuration files."
  exit 1
fi

echo "PASS: Nginx configuration is valid and service is running."
exit 0
