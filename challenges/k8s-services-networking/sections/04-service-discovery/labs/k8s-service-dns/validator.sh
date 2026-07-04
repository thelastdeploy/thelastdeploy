#!/bin/bash
# validator.sh — k8s-services-networking / 04-service-discovery / k8s-service-dns
set -euo pipefail

CONTEXT="kind-tld-k8s-service-dns"
FILE="$HOME/k8s-services-networking/dns-resolve.txt"

# Verify file exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Did you resolve the service DNS and save the output?"
  exit 1
fi

# Verify it contains backend-service name or cluster.local
if ! grep -q "backend-service" "$FILE"; then
  echo "FAIL: File '$FILE' does not contain reference to 'backend-service'."
  exit 1
fi

# Retrieve actual ClusterIP of service
SVC_IP=$(kubectl --context="$CONTEXT" get service backend-service -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "")

if [ -z "$SVC_IP" ]; then
  echo "FAIL: Service 'backend-service' not found in cluster."
  exit 1
fi

# Verify the file resolves to the correct ClusterIP
if ! grep -q "$SVC_IP" "$FILE"; then
  echo "FAIL: DNS resolve file does not contain the correct Service ClusterIP ($SVC_IP)."
  exit 1
fi

echo "PASS: Service DNS successfully resolved and verified!"
exit 0
