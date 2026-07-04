#!/bin/bash
# validator.sh — k8s-services-networking / 02-services / k8s-access-service
set -euo pipefail

FILE="$HOME/k8s-services-networking/backend-response.html"

if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Did you save the curl response?"
  exit 1
fi

if ! grep -q "Welcome to nginx!" "$FILE"; then
  echo "FAIL: File '$FILE' does not contain the expected backend response (Nginx welcome page)."
  exit 1
fi

echo "PASS: Successfully accessed the internal cluster service from the client pod!"
exit 0
