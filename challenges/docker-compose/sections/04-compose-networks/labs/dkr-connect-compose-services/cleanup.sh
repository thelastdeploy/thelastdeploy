#!/bin/bash
# cleanup.sh — docker-compose / 04-compose-networks / dkr-connect-compose-services
docker compose -f "$HOME/docker-compose/networks/docker-compose.yml" down -v || true
rm -rf "$HOME/docker-compose/networks"
echo "Cleanup complete."
