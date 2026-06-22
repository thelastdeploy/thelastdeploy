#!/bin/bash
# validator.sh — docker-containers / 04-exec-into-container / dkr-open-container-shell
set -euo pipefail

# Check if container interactive-shell-target exists and is running
if ! docker ps --filter name=interactive-shell-target --format '{{.Names}}' | grep -q "interactive-shell-target"; then
  echo "FAIL: Container 'interactive-shell-target' not found running."
  exit 1
fi

# Fetch actual internal hostname of the container
EXPECTED_HOSTNAME=$(docker inspect interactive-shell-target --format '{{.Config.Hostname}}' 2>/dev/null || echo "")

if [ -z "$EXPECTED_HOSTNAME" ]; then
  echo "FAIL: Could not determine expected hostname of container."
  exit 1
fi

# Read /tmp/touchme inside container
CONTENT=$(docker exec interactive-shell-target cat /tmp/touchme 2>/dev/null || echo "")
CONTENT_CLEAN=$(echo "$CONTENT" | tr -d '\r\n' | xargs)

if [ -z "$CONTENT_CLEAN" ]; then
  echo "FAIL: /tmp/touchme is empty. Did you write the hostname into it?"
  exit 1
fi

if [ "$CONTENT_CLEAN" != "$EXPECTED_HOSTNAME" ]; then
  echo "FAIL: Content inside /tmp/touchme does not match container's hostname. Got: '$CONTENT_CLEAN', Expected: '$EXPECTED_HOSTNAME'"
  exit 1
fi

echo "PASS: Successfully wrote hostname inside container file."
exit 0
