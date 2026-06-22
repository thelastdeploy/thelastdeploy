#!/bin/bash
# validator.sh — docker-containers / 05-environment-variables / dkr-fix-missing-env-var
set -euo pipefail

# Check if container db-connector exists and is running
if ! docker ps --filter name=db-connector --format '{{.Names}}' | grep -q "db-connector"; then
  echo "FAIL: Container 'db-connector' not found running."
  exit 1
fi

# Verify environment variable inside the container
ENV_VAR=$(docker exec db-connector env | grep "DB_HOST=" || echo "")

if [ -z "$ENV_VAR" ]; then
  echo "FAIL: Environment variable 'DB_HOST' is not set inside container."
  exit 1
fi

VAL="${ENV_VAR#DB_HOST=}"
if [ "$VAL" != "database.internal" ]; then
  echo "FAIL: DB_HOST environment variable has incorrect value. Got: '$VAL', Expected: 'database.internal'"
  exit 1
fi

echo "PASS: Environment variable correctly configured."
exit 0
