#!/bin/bash
# cleanup.sh — docker-containers / 04-exec-into-container / dkr-fix-file-inside-container
echo "Removing app-to-fix container..."
docker rm -f app-to-fix || true
echo "Cleanup completed!"
