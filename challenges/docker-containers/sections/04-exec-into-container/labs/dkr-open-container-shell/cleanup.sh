#!/bin/bash
# cleanup.sh — docker-containers / 04-exec-into-container / dkr-open-container-shell
echo "Removing interactive-shell-target container..."
docker rm -f interactive-shell-target || true
echo "Cleanup completed!"
