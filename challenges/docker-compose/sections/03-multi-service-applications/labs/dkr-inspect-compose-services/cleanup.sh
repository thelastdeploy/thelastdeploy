#!/bin/bash
# cleanup.sh — docker-compose / 03-multi-service-applications / dkr-inspect-compose-services
docker compose -f "$HOME/docker-compose/multi-service/docker-compose.yml" down -v || true
rm -rf "$HOME/docker-compose/multi-service"
echo "Cleanup complete."
