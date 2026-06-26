#!/bin/bash
# validator.sh — docker-compose / 04-compose-networks / dkr-connect-compose-services
set -euo pipefail

# 1. Get container IDs
WEB_CID=$(docker ps --filter "label=com.docker.compose.project=networks" --filter "label=com.docker.compose.service=web" --filter "status=running" -q)
API_CID=$(docker ps --filter "label=com.docker.compose.project=networks" --filter "label=com.docker.compose.service=api" --filter "status=running" -q)
DB_CID=$(docker ps --filter "label=com.docker.compose.project=networks" --filter "label=com.docker.compose.service=db" --filter "status=running" -q)

if [ -z "$WEB_CID" ] || [ -z "$API_CID" ] || [ -z "$DB_CID" ]; then
  echo "FAIL: Make sure 'web', 'api', and 'db' services are running."
  exit 1
fi

# 2. Inspect networks for web (should contain frontend-net and NOT backend-net)
WEB_NETS=$(docker inspect "$WEB_CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}')
if [[ "$WEB_NETS" != *"frontend-net"* && "$WEB_NETS" != *"frontend_net"* ]]; then
  echo "FAIL: 'web' is not connected to 'frontend-net'. Connected: '$WEB_NETS'"
  exit 1
fi
if [[ "$WEB_NETS" == *"backend-net"* || "$WEB_NETS" == *"backend_net"* ]]; then
  echo "FAIL: 'web' should not be connected to 'backend-net' for network isolation."
  exit 1
fi

# 3. Inspect networks for db (should contain backend-net and NOT frontend-net)
DB_NETS=$(docker inspect "$DB_CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}')
if [[ "$DB_NETS" != *"backend-net"* && "$DB_NETS" != *"backend_net"* ]]; then
  echo "FAIL: 'db' is not connected to 'backend-net'. Connected: '$DB_NETS'"
  exit 1
fi
if [[ "$DB_NETS" == *"frontend-net"* || "$DB_NETS" == *"frontend_net"* ]]; then
  echo "FAIL: 'db' should not be connected to 'frontend-net' for network isolation."
  exit 1
fi

# 4. Inspect networks for api (should contain both)
API_NETS=$(docker inspect "$API_CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}')
if [[ "$API_NETS" != *"frontend-net"* && "$API_NETS" != *"frontend_net"* ]]; then
  echo "FAIL: 'api' is not connected to 'frontend-net'. Connected: '$API_NETS'"
  exit 1
fi
if [[ "$API_NETS" != *"backend-net"* && "$API_NETS" != *"backend_net"* ]]; then
  echo "FAIL: 'api' is not connected to 'backend-net'. Connected: '$API_NETS'"
  exit 1
fi

echo "PASS: Network isolation verified between web, api, and db."
exit 0
