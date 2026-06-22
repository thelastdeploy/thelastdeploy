#!/bin/bash
# cleanup.sh — docker-containers / 02-container-logs / dkr-find-container-error
echo "Removing buggy-app container..."
docker rm -f buggy-app || true

echo "Removing test files..."
rm -f "$HOME/docker-test/error_msg.txt"

echo "Cleanup completed!"
