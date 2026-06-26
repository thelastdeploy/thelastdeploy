#!/bin/bash
# validator.sh — docker-compose / 02-first-compose-file / dkr-create-compose-file
set -euo pipefail

COMPOSE_PATH="$HOME/docker-compose/first-compose/docker-compose.yml"

# 1. Check if compose file exists
if [ ! -f "$COMPOSE_PATH" ]; then
  echo "FAIL: docker-compose.yml not found at '$COMPOSE_PATH'."
  exit 1
fi

# 2. Use python to parse and validate YAML contents
python3 -c "
import yaml
try:
    with open('$COMPOSE_PATH') as f:
        config = yaml.safe_load(f)
    
    services = config.get('services', {})
    if 'web' not in services:
        print('FAIL: Could not find service named \"web\" in services.')
        exit(1)
        
    web = services['web']
    image = web.get('image', '')
    if image != 'nginx:alpine':
        print(f'FAIL: Service \"web\" image is \"{image}\", expected \"nginx:alpine\".')
        exit(1)
        
    ports = web.get('ports', [])
    if not ports or '8080:80' not in [str(p) for p in ports]:
        print(f'FAIL: Port mapping \"8080:80\" not found under service \"web\". Found ports: {ports}')
        exit(1)
        
    print('PASS')
except Exception as e:
    print(f'FAIL: Invalid YAML formatting or parse error: {e}')
    exit(1)
"

# Handle python exit code
exit $?
