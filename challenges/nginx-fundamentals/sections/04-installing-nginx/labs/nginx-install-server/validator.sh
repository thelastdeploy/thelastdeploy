#!/bin/bash
# validator.sh — nginx-fundamentals / 04-installing-nginx / nginx-install-server
set -euo pipefail

if ! which nginx &>/dev/null; then
  echo "FAIL: Nginx is not installed or not in the system PATH. Please install Nginx using your system's package manager (e.g. 'sudo apt install nginx' or 'brew install nginx')."
  exit 1
fi

echo "PASS: Nginx is successfully installed"
exit 0
