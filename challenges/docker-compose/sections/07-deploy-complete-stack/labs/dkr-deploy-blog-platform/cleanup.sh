#!/bin/bash
# cleanup.sh — docker-compose / 07-deploy-complete-stack / dkr-deploy-blog-platform
docker compose -f "$HOME/docker-compose/blog-platform/docker-compose.yml" down -v || true
rm -rf "$HOME/docker-compose/blog-platform"
echo "Cleanup complete."
