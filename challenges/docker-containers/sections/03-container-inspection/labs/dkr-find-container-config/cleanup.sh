#!/bin/bash
# cleanup.sh — docker-containers / 03-container-inspection / dkr-find-container-config
echo "Removing config-target container..."
docker rm -f config-target || true

echo "Removing test files..."
rm -f "$HOME/docker-test/container_ip.txt"

echo "Cleanup completed!"
