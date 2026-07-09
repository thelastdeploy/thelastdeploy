#!/bin/bash
# validator.sh — nginx-reverse-proxy / 04-upstream-blocks / nginx-create-upstream
set -euo pipefail

# Verify upstream is configured in nginx.conf or conf.d/*.conf
if ! grep -r -q "upstream[[:space:]]\+backend_servers" /etc/nginx/nginx.conf /etc/nginx/conf.d/ &>/dev/null; then
  echo "FAIL: Upstream block 'backend_servers' not found in configuration files."
  exit 1
fi

# Ensure both servers are present in the matched block
# Let's read the full configs and verify
CONFIG_DUMP=$(nginx -T 2>/dev/null || true)
if ! echo "$CONFIG_DUMP" | grep -A 5 "upstream[[:space:]]\+backend_servers" | grep -q "server[[:space:]]\+127.0.0.1:8001"; then
  echo "FAIL: Server '127.0.0.1:8001' not found inside upstream 'backend_servers'."
  exit 1
fi

if ! echo "$CONFIG_DUMP" | grep -A 5 "upstream[[:space:]]\+backend_servers" | grep -q "server[[:space:]]\+127.0.0.1:8002"; then
  echo "FAIL: Server '127.0.0.1:8002' not found inside upstream 'backend_servers'."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Upstream block correctly defined."
exit 0
