#!/bin/bash
# validator.sh — docker-containers / 01-running-containers / dkr-run-detached-container
set -euo pipefail

# Check if container background-sleeper exists
if ! docker ps -a --filter name=background-sleeper --format '{{.Names}}' | grep -q "background-sleeper"; then
  echo "FAIL: Container 'background-sleeper' not found."
  exit 1
fi

# Check if it is running
RUNNING=$(docker inspect background-sleeper --format '{{.State.Running}}')
if [ "$RUNNING" != "true" ]; then
  echo "FAIL: Container 'background-sleeper' is not running."
  exit 1
fi

# Check if command matches sleep 500
CMD=$(docker inspect background-sleeper --format '{{.Config.Cmd}}')
if [[ "$CMD" != *"sleep"* ]] || [[ "$CMD" != *"500"* ]]; then
  echo "FAIL: Container 'background-sleeper' is not running 'sleep 500'. Got command: '$CMD'"
  exit 1
fi

echo "PASS: Detached container started successfully."
exit 0
