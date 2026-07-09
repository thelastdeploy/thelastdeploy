#!/bin/bash
# cleanup.sh — restore backups of configuration
set -euo pipefail

if [ -f /etc/nginx/sites-available/default.bak ]; then
  sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
  sudo rm -f /etc/nginx/sites-available/default.bak
fi

sudo rm -f /etc/nginx/sites-enabled/duplicate-default
sudo rm -f /etc/nginx/sites-available/duplicate-default

sudo systemctl start nginx || true
