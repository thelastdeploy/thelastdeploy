#!/bin/bash
# validator.sh — docker-containers / 03-container-inspection / dkr-find-container-config
set -euo pipefail

FILE="$HOME/docker-test/container_ip.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File ~/docker-test/container_ip.txt not found."
  exit 1
fi

USER_IP=$(tr -d '\r\n' < "$FILE" | xargs)

if [ -z "$USER_IP" ]; then
  echo "FAIL: The IP address file is empty."
  exit 1
fi

# Fetch actual container IP
EXPECTED_IP=$(docker inspect config-target --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 2>/dev/null || echo "")

if [ -z "$EXPECTED_IP" ]; then
  # Fallback if bridge network settings are nested differently
  EXPECTED_IP=$(docker inspect config-target --format '{{.NetworkSettings.IPAddress}}' 2>/dev/null || echo "")
fi

if [ -z "$EXPECTED_IP" ]; then
  echo "FAIL: Could not determine expected IP for config-target. Is the container running?"
  exit 1
fi

if [ "$USER_IP" != "$EXPECTED_IP" ]; then
  echo "FAIL: IP address inside container_ip.txt is incorrect. Got: '$USER_IP', Expected: '$EXPECTED_IP'"
  exit 1
fi

echo "PASS: Successfully inspected and saved container IP."
exit 0
