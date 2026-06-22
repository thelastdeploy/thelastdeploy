#!/bin/bash
# validator.sh — docker-containers / 01-running-containers / dkr-name-a-container
set -euo pipefail

# Check if the container custom-app exists
if ! docker ps -a --filter name=custom-app --format '{{.Names}}' | grep -q "custom-app"; then
  echo "FAIL: Container 'custom-app' not found."
  exit 1
fi

# Check if it is running
RUNNING=$(docker inspect custom-app --format '{{.State.Running}}')
if [ "$RUNNING" != "true" ]; then
  echo "FAIL: Container 'custom-app' is not running."
  exit 1
fi

# Check if the command is running sleep 1000
CMD=$(docker inspect custom-app --format '{{.Config.Cmd}}')
if [[ "$CMD" != *"sleep"* ]] || [[ "$CMD" != *"1000"* ]]; then
  echo "FAIL: Container 'custom-app' is not running 'sleep 1000'. Got command: '$CMD'"
  exit 1
fi

echo "PASS: Container custom-app successfully started."
exit 0
