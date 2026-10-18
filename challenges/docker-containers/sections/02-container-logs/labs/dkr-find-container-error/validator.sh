#!/bin/bash
# validator.sh — docker-containers / 02-container-logs / dkr-find-container-error
set -euo pipefail

FILE="$HOME/docker-test/error_msg.txt"

if [ ! -f "$FILE" ] || [ ! -s "$FILE" ]; then
  echo "FAIL: File ~/docker-test/error_msg.txt not found or is empty."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)

if [ "$CONTENT" != "db_connection_failed" ]; then
  echo "FAIL: Error message inside error_msg.txt is incorrect. Got: '$CONTENT'"
  exit 1
fi

echo "PASS: Successfully extracted the critical error log."
exit 0
