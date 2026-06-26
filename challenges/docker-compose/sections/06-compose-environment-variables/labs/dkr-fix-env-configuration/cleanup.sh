#!/bin/bash
# cleanup.sh — docker-compose / 06-compose-environment-variables / dkr-fix-env-configuration
docker compose -f "$HOME/docker-compose/env-vars/docker-compose.yml" down -v || true
rm -rf "$HOME/docker-compose/env-vars"
echo "Cleanup complete."
