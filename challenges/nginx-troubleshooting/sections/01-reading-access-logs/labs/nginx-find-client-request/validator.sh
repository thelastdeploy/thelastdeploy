#!/bin/bash
# validator.sh — nginx-troubleshooting / 01-reading-access-logs / nginx-find-client-request
set -euo pipefail

FILE="/tmp/client_ip.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File /tmp/client_ip.txt does not exist."
  exit 1
fi

IP=$(cat "$FILE" | xargs)

if [ "$IP" != "192.168.12.34" ]; then
  echo "FAIL: Correct IP address '192.168.12.34' not found in /tmp/client_ip.txt."
  exit 1
fi

echo "PASS: Client IP extracted and written successfully."
exit 0
