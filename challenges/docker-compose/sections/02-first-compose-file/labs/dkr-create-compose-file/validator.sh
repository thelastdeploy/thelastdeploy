#!/bin/bash
# validator.sh — docker-compose / 02-first-compose-file / dkr-create-compose-file
set -euo pipefail

COMPOSE_PATH="$HOME/docker-compose/first-compose/docker-compose.yml"

# 1. Check if compose file exists
if [ ! -f "$COMPOSE_PATH" ] || [ ! -s "$COMPOSE_PATH" ]; then
  echo "FAIL: docker-compose.yml not found or is empty at '$COMPOSE_PATH'."
  exit 1
fi

# 2. Use docker compose config and python json module to validate contents
CONFIG_JSON=$(docker compose -f "$COMPOSE_PATH" config --format json 2>/dev/null || echo "")
if [ -z "$CONFIG_JSON" ]; then
  echo "FAIL: docker-compose.yml has invalid syntax or failed to parse."
  exit 1
fi

python3 -c "
import json, sys

try:
    config = json.loads('''$CONFIG_JSON''')
    services = config.get('services', {})
    if 'web' not in services:
        print('FAIL: Could not find service named \"web\" in services.')
        sys.exit(1)
        
    web = services['web']
    image = web.get('image', '')
    if image != 'nginx:alpine':
        print(f'FAIL: Service \"web\" image is \"{image}\", expected \"nginx:alpine\".')
        sys.exit(1)
        
    ports = web.get('ports', [])
    port_match = False
    for p in ports:
        if isinstance(p, dict):
            if str(p.get('published')) == '8080' and (str(p.get('target')) == '80' or p.get('target') == 80):
                port_match = True
                break
        elif '8080:80' in str(p):
            port_match = True
            break

    if not port_match:
        print(f'FAIL: Port mapping \"8080:80\" not found under service \"web\". Found ports: {ports}')
        sys.exit(1)
        
    print('PASS: Successfully validated docker-compose.yml configuration.')
except Exception as e:
    print(f'FAIL: Parse error: {e}')
    sys.exit(1)
"

exit $?
