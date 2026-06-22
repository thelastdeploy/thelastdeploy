#!/bin/bash
# cleanup.sh — docker-containers / 01-running-containers / dkr-run-detached-container
echo "Removing background-sleeper container..."
docker rm -f background-sleeper || true
echo "Cleanup completed!"
