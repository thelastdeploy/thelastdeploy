#!/bin/bash
# validator.sh — docker-containers / 02-container-logs / dkr-read-container-logs
set -euo pipefail

FILE="$HOME/docker-test/container_flag.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File ~/docker-test/container_flag.txt not found."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$FILE" | xargs)

if [ "$CONTENT" != "SECRET_FLAG=docker_logging_master" ]; then
  echo "FAIL: Content inside container_flag.txt is incorrect. Got: '$CONTENT'"
  exit 1
fi

echo "PASS: Successfully retrieved the secret flag from container logs."
exit 0
