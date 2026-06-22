#!/bin/bash
# validator.sh — docker-containers / 07-debug-failing-container / dkr-recover-crashing-container
set -euo pipefail

# Check if container crashing-service exists
if ! docker ps -a --filter name=crashing-service --format '{{.Names}}' | grep -q "crashing-service"; then
  echo "FAIL: Container 'crashing-service' not found."
  exit 1
fi

# Check if it is running
RUNNING=$(docker inspect crashing-service --format '{{.State.Running}}')
if [ "$RUNNING" != "true" ]; then
  echo "FAIL: Container 'crashing-service' is not running."
  exit 1
fi

# Check if the execution command matches sleep 1000
CMD=$(docker inspect crashing-service --format '{{.Config.Cmd}}')
if [[ "$CMD" != *"sleep"* ]] || [[ "$CMD" != *"1000"* ]] || [[ "$CMD" == *"sleepy"* ]]; then
  echo "FAIL: Container 'crashing-service' command has not been corrected. Got command: '$CMD'"
  exit 1
fi

echo "PASS: Successfully debugged, replaced and started crashing-service."
exit 0
