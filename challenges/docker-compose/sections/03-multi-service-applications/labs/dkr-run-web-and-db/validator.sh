#!/bin/bash
# validator.sh — docker-compose / 03-multi-service-applications / dkr-run-web-and-db
set -euo pipefail

# 1. Find running container for web service
WEB_CID=$(docker ps --filter "label=com.docker.compose.project=multi-service" --filter "label=com.docker.compose.service=web" --filter "status=running" -q)

if [ -z "$WEB_CID" ]; then
  echo "FAIL: Running container for service 'web' in project 'multi-service' not found."
  exit 1
fi

# 2. Check port mapping for web service on 8081
WEB_PORT=$(docker inspect "$WEB_CID" --format '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null || echo "")

if [ "$WEB_PORT" != "8081" ]; then
  echo "FAIL: Container 'web' is not mapped to host port 8081. Got: '$WEB_PORT'"
  exit 1
fi

# 3. Find running container for db service
DB_CID=$(docker ps --filter "label=com.docker.compose.project=multi-service" --filter "label=com.docker.compose.service=db" --filter "status=running" -q)

if [ -z "$DB_CID" ]; then
  echo "FAIL: Running container for service 'db' in project 'multi-service' not found."
  exit 1
fi

# 4. Check image name for db service
DB_IMAGE=$(docker inspect "$DB_CID" --format '{{.Config.Image}}')

if [[ "$DB_IMAGE" != *"postgres:15-alpine"* ]]; then
  echo "FAIL: Service 'db' is not using image 'postgres:15-alpine'. Got: '$DB_IMAGE'"
  exit 1
fi

# 5. Check environment variables
DB_ENV=$(docker inspect "$DB_CID" --format '{{range .Config.Env}}{{.}}
{{end}}')

if ! echo "$DB_ENV" | grep -q "POSTGRES_USER=admin"; then
  echo "FAIL: Database POSTGRES_USER environment variable is not 'admin'."
  exit 1
fi

if ! echo "$DB_ENV" | grep -q "POSTGRES_PASSWORD=secret"; then
  echo "FAIL: Database POSTGRES_PASSWORD environment variable is not 'secret'."
  exit 1
fi

if ! echo "$DB_ENV" | grep -q "POSTGRES_DB=mydb"; then
  echo "FAIL: Database POSTGRES_DB environment variable is not 'mydb'."
  exit 1
fi

echo "PASS: Multi-service stack running web on 8081 and db with correct credentials."
exit 0
