#!/bin/bash
# validator.sh — nginx-troubleshooting / 02-reading-error-logs / nginx-identify-startup-error
set -euo pipefail

FILE="/tmp/failed_port.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File /tmp/failed_port.txt does not exist."
  exit 1
fi

PORT=$(cat "$FILE" | xargs)

if [ "$PORT" != "9999" ]; then
  echo "FAIL: Correct port '9999' not found in /tmp/failed_port.txt."
  exit 1
fi

echo "PASS: Bind failure port identified successfully."
exit 0
