#!/bin/bash
# validator.sh — nginx-fundamentals / 07-recover-a-broken-installation / nginx-fix-installation
set -euo pipefail

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test is still failing. Run 'sudo nginx -t' to find the syntax error."
  exit 1
fi

if ! systemctl is-active nginx &>/dev/null; then
  echo "FAIL: Nginx configuration is fixed, but the Nginx service is not running. Run 'sudo systemctl start nginx' to start the service."
  exit 1
fi

# Verify the error string is no longer in the default configuration
if grep -q "broken_syntax_here" /etc/nginx/sites-available/default; then
  echo "FAIL: Junk configuration 'broken_syntax_here' is still present in /etc/nginx/sites-available/default."
  exit 1
fi

echo "PASS: Configuration fixed and Nginx successfully running!"
exit 0
