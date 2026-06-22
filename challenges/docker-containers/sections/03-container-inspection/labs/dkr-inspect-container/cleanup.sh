#!/bin/bash
# cleanup.sh — docker-containers / 03-container-inspection / dkr-inspect-container
echo "Removing inspect-target container..."
docker rm -f inspect-target || true

echo "Removing test files..."
rm -f "$HOME/docker-test/log_path.txt"

echo "Cleanup completed!"
