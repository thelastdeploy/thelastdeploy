#!/bin/bash
# validator.sh — docker-containers / 05-environment-variables / dkr-run-with-env-var
set -euo pipefail

# Check if container env-app exists and is running
if ! docker ps --filter name=env-app --format '{{.Names}}' | grep -q "env-app"; then
  echo "FAIL: Container 'env-app' not found running."
  exit 1
fi

# Verify environment variables inside container
ENV_VARS=$(docker exec env-app env)

# Check APP_ENV
if ! echo "$ENV_VARS" | grep -q "APP_ENV=production"; then
  echo "FAIL: Environment variable 'APP_ENV' is not set to 'production'."
  exit 1
fi

# Check DEBUG
if ! echo "$ENV_VARS" | grep -q "DEBUG=false"; then
  echo "FAIL: Environment variable 'DEBUG' is not set to 'false'."
  exit 1
fi

echo "PASS: Container env-app started with correct environment variables."
exit 0
