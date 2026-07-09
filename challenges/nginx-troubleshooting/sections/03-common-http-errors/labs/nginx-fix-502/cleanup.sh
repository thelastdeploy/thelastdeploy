#!/bin/bash
# cleanup.sh — restore backups of configuration
set -euo pipefail

# Kill mock python server on 8080
sudo kill -9 $(sudo lsof -t -i:8080) &>/dev/null || true
rm -rf /tmp/mock-backend

if [ -f /etc/nginx/sites-available/default.bak ]; then
  sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
  sudo rm -f /etc/nginx/sites-available/default.bak
fi

sudo systemctl reload nginx || sudo systemctl start nginx || true
