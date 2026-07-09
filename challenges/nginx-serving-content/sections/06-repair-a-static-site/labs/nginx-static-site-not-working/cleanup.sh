#!/bin/bash
# cleanup.sh — restore backups of configuration
set -euo pipefail

sudo chmod 755 /var/www/html
sudo chmod 644 /var/www/html/index.html || true

sudo systemctl reload nginx || sudo systemctl start nginx || true
