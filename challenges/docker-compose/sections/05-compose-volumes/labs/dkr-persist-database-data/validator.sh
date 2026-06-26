#!/bin/bash
# validator.sh — docker-compose / 05-compose-volumes / dkr-persist-database-data
set -euo pipefail

# 1. Get container ID
DB_CID=$(docker ps --filter "label=com.docker.compose.project=volumes" --filter "label=com.docker.compose.service=db" --filter "status=running" -q)

if [ -z "$DB_CID" ]; then
  echo "FAIL: Running container for database service 'db' not found."
  exit 1
fi

# 2. Inspect mounts
MOUNTS=$(docker inspect "$DB_CID" --format '{{range .Mounts}}{{.Type}} {{.Destination}} {{.Name}}
{{end}}')

# Check for volume type mount at destination /var/lib/postgresql/data containing db_data
if ! echo "$MOUNTS" | grep -qE "volume /var/lib/postgresql/data (.*_db_data|db_data)"; then
  echo "FAIL: Named volume mount at '/var/lib/postgresql/data' not configured correctly. Mounts found: '$MOUNTS'"
  exit 1
fi

echo "PASS: Persistent named volume configured correctly for database."
exit 0
