#!/bin/bash
# cleanup.sh — docker-containers / 01-running-containers / dkr-name-a-container
echo "Removing custom-app container..."
docker rm -f custom-app || true
echo "Cleanup completed!"
