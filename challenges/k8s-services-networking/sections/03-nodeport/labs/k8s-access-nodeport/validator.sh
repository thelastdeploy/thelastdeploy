#!/bin/bash
# validator.sh — k8s-services-networking / 03-nodeport / k8s-access-nodeport
set -euo pipefail

CONTEXT="kind-tld-k8s-access-nodeport"
FILE="$HOME/k8s-services-networking/nodeport-response.html"

# Verify file exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Did you curl the NodePort service and save the response?"
  exit 1
fi

# Verify the file contains nginx welcome greeting
if ! grep -q "Welcome to nginx!" "$FILE"; then
  echo "FAIL: File '$FILE' does not contain the expected Nginx response. Make sure you curled the NodePort port (30080)."
  exit 1
fi

# Get node internal IP
NODE_IP=$(kubectl --context="$CONTEXT" get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null || echo "")
if [ -z "$NODE_IP" ]; then
  echo "FAIL: Could not retrieve Kind Node IP."
  exit 1
fi

# Live test connectivity to the NodePort from the host container running validator
if ! curl -s --connect-timeout 3 "http://${NODE_IP}:30080" | grep -q "Welcome to nginx!"; then
  echo "FAIL: Unable to connect to the NodePort service at http://${NODE_IP}:30080 from the host network."
  exit 1
fi

echo "PASS: NodePort service accessed successfully!"
exit 0
