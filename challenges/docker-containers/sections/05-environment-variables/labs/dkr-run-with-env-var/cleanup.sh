#!/bin/bash
# cleanup.sh — docker-containers / 05-environment-variables / dkr-run-with-env-var
echo "Removing env-app container..."
docker rm -f env-app || true
echo "Cleanup completed!"
