#!/bin/bash
# cleanup.sh — docker-containers / 06-resource-limits / dkr-limit-container-memory
echo "Removing memory-capped container..."
docker rm -f memory-capped || true
echo "Cleanup completed!"
