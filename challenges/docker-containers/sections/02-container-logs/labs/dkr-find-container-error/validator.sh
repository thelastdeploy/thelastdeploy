#!/bin/bash
# validator.sh — docker-containers / 02-container-logs / dkr-find-container-error
set -euo pipefail

FILE="$HOME/docker-test/error_msg.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File ~/docker-test/error_msg.txt not found."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)

if [ "$CONTENT" != "db_connection_failed" ]; then
  echo "FAIL: Error message inside error_msg.txt is incorrect. Got: '$CONTENT'"
  exit 1
fi

echo "PASS: Successfully extracted the critical error log."
exit 0
