#!/bin/bash
# cleanup.sh — docker-containers / 02-container-logs / dkr-read-container-logs
echo "Removing logger-app container..."
docker rm -f logger-app || true

echo "Removing test files..."
rm -f "$HOME/docker-test/container_flag.txt"

echo "Cleanup completed!"
