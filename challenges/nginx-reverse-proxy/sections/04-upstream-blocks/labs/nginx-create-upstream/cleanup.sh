#!/bin/bash
# cleanup.sh — restore backups of configuration
set -euo pipefail

if [ -f /etc/nginx/nginx.conf.bak ]; then
  sudo cp /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
  sudo rm -f /etc/nginx/nginx.conf.bak
fi

sudo rm -f /etc/nginx/conf.d/upstream.conf

sudo systemctl reload nginx || sudo systemctl start nginx || true
