#!/bin/bash
# validator.sh — nginx-fundamentals / 05-running-and-managing-nginx / nginx-stop-service
set -euo pipefail

if systemctl is-active nginx &>/dev/null; then
  echo "FAIL: Nginx service is still active/running. Run 'sudo systemctl stop nginx' to stop the service."
  exit 1
fi

echo "PASS: Nginx service is stopped."
exit 0
