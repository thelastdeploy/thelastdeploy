#!/bin/bash
# validator.sh — docker-containers / 06-resource-limits / dkr-limit-container-memory
set -euo pipefail

# Check if container memory-capped exists and is running
if ! docker ps --filter name=memory-capped --format '{{.Names}}' | grep -q "memory-capped"; then
  echo "FAIL: Container 'memory-capped' not found running."
  exit 1
fi

# Fetch Memory HostConfig
MEMORY_LIMIT=$(docker inspect memory-capped --format '{{.HostConfig.Memory}}' 2>/dev/null || echo "")

if [ -z "$MEMORY_LIMIT" ] || [ "$MEMORY_LIMIT" -eq 0 ]; then
  echo "FAIL: Memory limit has not been set for container 'memory-capped'."
  exit 1
fi

# 128 MB = 134217728 bytes
EXPECTED_BYTES=134217728

if [ "$MEMORY_LIMIT" -ne "$EXPECTED_BYTES" ]; then
  echo "FAIL: Memory limit is incorrect. Got: $MEMORY_LIMIT bytes, Expected: $EXPECTED_BYTES bytes (128m)."
  exit 1
fi

echo "PASS: Container memory limit successfully verified."
exit 0
