#!/bin/bash
# validator.sh — nginx-troubleshooting / 04-debugging-upstreams / nginx-backend-offline
set -euo pipefail

# Curl http://localhost/app and verify response is "BACKEND LIVE"
RESPONSE=$(curl -s http://localhost/app)

if [ "$RESPONSE" != "BACKEND LIVE" ]; then
  echo "FAIL: Expected 'BACKEND LIVE' from http://localhost/app but got '$RESPONSE'."
  exit 1
fi

echo "PASS: Offline backend started and proxied successfully."
exit 0
