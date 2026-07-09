#!/bin/bash
# validator.sh — nginx-configuration / 05-testing-configurations / nginx-configtest
set -euo pipefail

FILE="/tmp/config_test_result.txt"
if [ ! -f "$FILE" ]; then
  echo "FAIL: File /tmp/config_test_result.txt not found. Did you run 'sudo nginx -t 2> /tmp/config_test_result.txt'?"
  exit 1
fi

CONTENT=$(cat "$FILE")
if ! echo "$CONTENT" | grep -q "syntax is ok" || ! echo "$CONTENT" | grep -q "test is successful"; then
  echo "FAIL: The output saved in /tmp/config_test_result.txt does not show a successful Nginx configuration test."
  exit 1
fi

echo "PASS: Configuration test successfully logged."
exit 0
