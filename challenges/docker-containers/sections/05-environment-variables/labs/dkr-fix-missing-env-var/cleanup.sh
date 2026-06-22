#!/bin/bash
# cleanup.sh — docker-containers / 05-environment-variables / dkr-fix-missing-env-var
echo "Removing db-connector container..."
docker rm -f db-connector || true
echo "Cleanup completed!"
