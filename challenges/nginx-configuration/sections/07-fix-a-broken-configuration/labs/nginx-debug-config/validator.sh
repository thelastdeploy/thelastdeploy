#!/bin/bash
# validator.sh — nginx-configuration / 07-fix-a-broken-configuration / nginx-debug-config
set -euo pipefail

# Ensure Nginx config syntax is correct (conflicts resolved)
if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test is still failing. Check for duplicate default_server directives."
  exit 1
fi

if ! systemctl is-active nginx &>/dev/null; then
  echo "FAIL: Nginx configuration test passed, but Nginx service is not running. Run 'sudo systemctl start nginx' to start the service."
  exit 1
fi

# Ensure that the duplicate default server symlink is removed or its directive is deleted
if [ -f /etc/nginx/sites-enabled/duplicate-default ] && grep -q "default_server" /etc/nginx/sites-enabled/duplicate-default; then
  echo "FAIL: The duplicate-default file is still enabled and contains a default_server directive."
  exit 1
fi

echo "PASS: Configuration conflict successfully resolved and Nginx started."
exit 0
