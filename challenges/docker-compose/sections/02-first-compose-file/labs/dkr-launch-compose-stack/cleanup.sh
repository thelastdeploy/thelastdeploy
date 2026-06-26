#!/bin/bash
# cleanup.sh — docker-compose / 02-first-compose-file / dkr-launch-compose-stack
docker compose -f "$HOME/docker-compose/first-compose/docker-compose.yml" down -v || true
rm -rf "$HOME/docker-compose/first-compose"
echo "Cleanup complete."
