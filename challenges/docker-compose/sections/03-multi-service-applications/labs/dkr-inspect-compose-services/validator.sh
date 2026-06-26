#!/bin/bash
# validator.sh — docker-compose / 03-multi-service-applications / dkr-inspect-compose-services
set -euo pipefail

# 1. Count web containers running under project multi-service
WEB_COUNT=$(docker ps --filter "label=com.docker.compose.project=multi-service" --filter "label=com.docker.compose.service=web" --filter "status=running" -q | wc -l)

if [ "$WEB_COUNT" -ne 2 ]; then
  echo "FAIL: Expected exactly 2 running containers for service 'web', found: '$WEB_COUNT'."
  exit 1
fi

# 2. Count db containers running under project multi-service
DB_COUNT=$(docker ps --filter "label=com.docker.compose.project=multi-service" --filter "label=com.docker.compose.service=db" --filter "status=running" -q | wc -l)

if [ "$DB_COUNT" -ne 1 ]; then
  echo "FAIL: Service 'db' is not running."
  exit 1
fi

echo "PASS: Successfully scaled service 'web' to 2 instances!"
exit 0
