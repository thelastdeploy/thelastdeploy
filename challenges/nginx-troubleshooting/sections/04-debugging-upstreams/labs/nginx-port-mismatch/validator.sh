#!/bin/bash
# validator.sh — nginx-troubleshooting / 04-debugging-upstreams / nginx-port-mismatch
set -euo pipefail

# Curl http://localhost/app and verify response is "UPSTREAM OK"
RESPONSE=$(curl -s http://localhost/app)

if [ "$RESPONSE" != "UPSTREAM OK" ]; then
  echo "FAIL: Expected 'UPSTREAM OK' from http://localhost/app but got '$RESPONSE'."
  exit 1
fi

UPSTREAM_CONF="/etc/nginx/conf.d/upstream.conf"

# Verify that upstream port is 8081
if ! grep -q "server 127.0.0.1:8081;" "$UPSTREAM_CONF"; then
  echo "FAIL: The upstream port in /etc/nginx/conf.d/upstream.conf is not set to 8081."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Upstream port mismatch fixed successfully."
exit 0
