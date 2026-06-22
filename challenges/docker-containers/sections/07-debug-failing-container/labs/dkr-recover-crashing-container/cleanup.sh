#!/bin/bash
# cleanup.sh — docker-containers / 07-debug-failing-container / dkr-recover-crashing-container
echo "Removing crashing-service container..."
docker rm -f crashing-service || true
echo "Cleanup completed!"
