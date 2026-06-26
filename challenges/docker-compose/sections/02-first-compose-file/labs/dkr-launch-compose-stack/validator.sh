#!/bin/bash
# validator.sh — docker-compose / 02-first-compose-file / dkr-launch-compose-stack
set -euo pipefail

# 1. Find running container under compose project first-compose and service web
CONTAINER_ID=$(docker ps --filter "label=com.docker.compose.project=first-compose" --filter "label=com.docker.compose.service=web" --filter "status=running" -q)

if [ -z "$CONTAINER_ID" ]; then
  echo "FAIL: No running container found for project 'first-compose' and service 'web'."
  exit 1
fi

# 2. Check port mapping on 8080
PORT_MAPPED=$(docker inspect "$CONTAINER_ID" --format '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null || echo "")

if [ "$PORT_MAPPED" != "8080" ]; then
  echo "FAIL: Container 'web' is not mapped to host port 8080. Got: '$PORT_MAPPED'"
  exit 1
fi

# 3. Test HTTP responsiveness
if ! curl -s --connect-timeout 2 http://localhost:8080 >/dev/null; then
  echo "FAIL: Nginx container on port 8080 is not responding to requests."
  exit 1
fi

echo "PASS: Compose stack is up and running Nginx on port 8080!"
exit 0
