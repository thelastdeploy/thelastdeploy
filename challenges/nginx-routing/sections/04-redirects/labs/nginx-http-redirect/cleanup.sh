#!/bin/bash
# cleanup.sh — restore backups of configuration
set -euo pipefail

if [ -f /etc/nginx/sites-available/default.bak ]; then
  sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
  sudo rm -f /etc/nginx/sites-available/default.bak
fi

sudo systemctl reload nginx || sudo systemctl start nginx || true
