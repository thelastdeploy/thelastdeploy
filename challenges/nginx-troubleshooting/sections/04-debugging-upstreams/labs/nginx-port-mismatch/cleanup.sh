#!/bin/bash
# cleanup.sh — restore backups and kill python servers
set -euo pipefail

# Kill mock python server on 8081
sudo kill -9 $(sudo lsof -t -i:8081) &>/dev/null || true
rm -rf /tmp/backend-port

sudo rm -f /etc/nginx/conf.d/upstream.conf

if [ -f /etc/nginx/sites-available/default.bak ]; then
  sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
  sudo rm -f /etc/nginx/sites-available/default.bak
fi

sudo systemctl reload nginx || sudo systemctl start nginx || true
