#!/bin/bash
# validator.sh — nginx-security-and-performance / 03-rate-limiting / nginx-limit-requests
set -euo pipefail

# Check if limit_req_zone is configured in nginx.conf
if ! grep -q "limit_req_zone.*mylimit" /etc/nginx/nginx.conf; then
  echo "FAIL: limit_req_zone named 'mylimit' not found in /etc/nginx/nginx.conf."
  exit 1
fi

# Check limit properties
if ! grep -q "rate=5r/s" /etc/nginx/nginx.conf; then
  echo "FAIL: Rate Limit is not set to 5r/s."
  exit 1
fi

CONFIG="/etc/nginx/sites-available/default"

# Verify limit_req is applied to /api/
if ! grep -A 5 "location.*/api" "$CONFIG" | grep -q "limit_req[[:space:]]\+zone=mylimit"; then
  echo "FAIL: Location /api/ block is missing 'limit_req zone=mylimit;' directive."
  exit 1
fi

if ! grep -A 5 "location.*/api" "$CONFIG" | grep -q "burst=10"; then
  echo "FAIL: Rate Limit burst capacity is not set to 10."
  exit 1
fi

if ! grep -A 5 "location.*/api" "$CONFIG" | grep -q "nodelay"; then
  echo "FAIL: 'nodelay' parameter not specified in limit_req directive."
  exit 1
fi

if ! sudo nginx -t &>/dev/null; then
  echo "FAIL: Nginx configuration test failed."
  exit 1
fi

echo "PASS: Rate limiting configured successfully."
exit 0
