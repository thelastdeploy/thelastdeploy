#!/bin/bash
# validator.sh — nginx-configuration / 05-testing-configurations / nginx-find-config-error
set -euo pipefail

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test is still failing. Run 'sudo nginx -t' to find the missing semicolon."
  exit 1
fi

# Double check if root directive has been fixed
if grep -q "root /var/www/html$" /etc/nginx/sites-available/default; then
  echo "FAIL: The root directive is still missing its semicolon."
  exit 1
fi

echo "PASS: Configuration test passes. Syntax error fixed."
exit 0
