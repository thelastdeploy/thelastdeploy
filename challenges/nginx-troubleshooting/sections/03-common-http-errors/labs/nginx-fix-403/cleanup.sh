#!/bin/bash
# cleanup.sh — restore permissions of index file
set -euo pipefail

sudo chmod 644 /var/www/html/index.html || true
sudo systemctl reload nginx || sudo systemctl start nginx || true
