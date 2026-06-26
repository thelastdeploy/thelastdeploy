#!/bin/bash
# cleanup.sh — docker-compose / 05-compose-volumes / dkr-persist-database-data
docker compose -f "$HOME/docker-compose/volumes/docker-compose.yml" down -v || true
rm -rf "$HOME/docker-compose/volumes"
echo "Cleanup complete."
