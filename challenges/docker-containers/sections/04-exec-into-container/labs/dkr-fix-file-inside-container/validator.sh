#!/bin/bash
# validator.sh — docker-containers / 04-exec-into-container / dkr-fix-file-inside-container
set -euo pipefail

# Check if container app-to-fix exists and is running
if ! docker ps --filter name=app-to-fix --format '{{.Names}}' | grep -q "app-to-fix"; then
  echo "FAIL: Container 'app-to-fix' not found running."
  exit 1
fi

# Read /app/config.txt inside container
CONTENT=$(docker exec app-to-fix cat /app/config.txt 2>/dev/null || echo "")
CONTENT_CLEAN=$(echo "$CONTENT" | tr -d '\r\n' | xargs)

if [ "$CONTENT_CLEAN" != "STATUS=fixed" ]; then
  echo "FAIL: File /app/config.txt has not been fixed inside container. Content: '$CONTENT_CLEAN'"
  exit 1
fi

echo "PASS: Successfully fixed configuration file inside running container."
exit 0
