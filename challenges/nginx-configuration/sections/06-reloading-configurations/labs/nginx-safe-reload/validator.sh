#!/bin/bash
# validator.sh — nginx-configuration / 06-reloading-configurations / nginx-safe-reload
set -euo pipefail

# Check if port 8085 is responding
if ! curl -s --connect-timeout 2 http://localhost:8085/ &>/dev/null; then
  echo "FAIL: Port 8085 is not responding. Did you configure Nginx to listen on port 8085 and run 'sudo systemctl reload nginx'?"
  exit 1
fi

echo "PASS: Configuration successfully reloaded and listening on port 8085."
exit 0
