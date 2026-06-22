#!/bin/bash
# validator.sh — docker-containers / 03-container-inspection / dkr-inspect-container
set -euo pipefail

FILE="$HOME/docker-test/log_path.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File ~/docker-test/log_path.txt not found."
  exit 1
fi

USER_PATH=$(tr -d '\r\n' < "$FILE" | xargs)

if [ -z "$USER_PATH" ]; then
  echo "FAIL: The log path file is empty."
  exit 1
fi

# Fetch actual container log path
EXPECTED_PATH=$(docker inspect inspect-target --format '{{.LogPath}}' 2>/dev/null || echo "")

if [ -z "$EXPECTED_PATH" ]; then
  echo "FAIL: Could not determine expected log path for inspect-target. Is the container running?"
  exit 1
fi

if [ "$USER_PATH" != "$EXPECTED_PATH" ]; then
  echo "FAIL: Log path inside log_path.txt is incorrect. Got: '$USER_PATH', Expected: '$EXPECTED_PATH'"
  exit 1
fi

echo "PASS: Successfully inspected and saved container LogPath."
exit 0
