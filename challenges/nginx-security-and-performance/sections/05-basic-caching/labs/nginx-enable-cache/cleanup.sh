#!/bin/bash
# cleanup.sh — restore backups of configuration
set -euo pipefail

if [ -f /etc/nginx/nginx.conf.bak ]; then
  sudo cp /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
  sudo rm -f /etc/nginx/nginx.conf.bak
fi

if [ -f /etc/nginx/sites-available/default.bak ]; then
  sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
  sudo rm -f /etc/nginx/sites-available/default.bak
fi

sudo rm -rf /var/cache/nginx

sudo systemctl reload nginx || sudo systemctl start nginx || true
