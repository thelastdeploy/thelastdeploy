#!/bin/bash
# validator.sh — docker-compose / 06-compose-environment-variables / dkr-fix-env-configuration
set -euo pipefail

# 1. Check if .env file exists and contains the password
ENV_PATH="$HOME/docker-compose/env-vars/.env"
if [ ! -f "$ENV_PATH" ]; then
  echo "FAIL: .env file not found at '$ENV_PATH'."
  exit 1
fi

if ! grep -q "DB_PASSWORD=supersecure123" "$ENV_PATH"; then
  echo "FAIL: .env file does not contain the correct DB_PASSWORD definition."
  exit 1
fi

# 2. Get container IDs
DB_CID=$(docker ps --filter "label=com.docker.compose.project=env-vars" --filter "label=com.docker.compose.service=db" --filter "status=running" -q)
APP_CID=$(docker ps --filter "label=com.docker.compose.project=env-vars" --filter "label=com.docker.compose.service=app" --filter "status=running" -q)

if [ -z "$DB_CID" ] || [ -z "$APP_CID" ]; then
  echo "FAIL: Make sure both 'db' and 'app' services are running."
  exit 1
fi

# 3. Inspect db environment variables
DB_ENV=$(docker inspect "$DB_CID" --format '{{range .Config.Env}}{{.}}
{{end}}')

if ! echo "$DB_ENV" | grep -q "POSTGRES_PASSWORD=supersecure123"; then
  echo "FAIL: Database container POSTGRES_PASSWORD environment variable is not 'supersecure123'."
  exit 1
fi

# 4. Inspect app environment variables
APP_ENV=$(docker inspect "$APP_CID" --format '{{range .Config.Env}}{{.}}
{{end}}')

if ! echo "$APP_ENV" | grep -q "DB_PASSWORD=supersecure123"; then
  echo "FAIL: Application container DB_PASSWORD environment variable is not 'supersecure123'."
  exit 1
fi

echo "PASS: Successfully configured stack environment using .env file."
exit 0
