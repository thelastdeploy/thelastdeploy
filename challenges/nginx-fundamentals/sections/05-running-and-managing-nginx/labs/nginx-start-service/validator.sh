#!/bin/bash
# validator.sh — nginx-fundamentals / 05-running-and-managing-nginx / nginx-start-service
set -euo pipefail

if ! systemctl is-active nginx &>/dev/null; then
  echo "FAIL: Nginx service is not active/running. Run 'sudo systemctl start nginx' to start the service."
  exit 1
fi

echo "PASS: Nginx service is active and running."
exit 0
