#!/bin/bash
# validator.sh — k8s-services-networking / 02-services / k8s-create-clusterip-service
set -euo pipefail

CONTEXT="kind-tld-k8s-create-clusterip-service"
SVC="backend-service"

# Check if Service exists
if ! kubectl --context="$CONTEXT" get service "$SVC" &>/dev/null; then
  echo "FAIL: Service '$SVC' not found. Please create it."
  exit 1
fi

# Check type is ClusterIP
TYPE=$(kubectl --context="$CONTEXT" get service "$SVC" -o jsonpath='{.spec.type}')
if [ "$TYPE" != "ClusterIP" ]; then
  echo "FAIL: Service '$SVC' is of type '$TYPE', but it must be 'ClusterIP'."
  exit 1
fi

# Check port is 80 and targetPort is 80
PORT=$(kubectl --context="$CONTEXT" get service "$SVC" -o jsonpath='{.spec.ports[0].port}')
TARGET_PORT=$(kubectl --context="$CONTEXT" get service "$SVC" -o jsonpath='{.spec.ports[0].targetPort}')

if [ "$PORT" != "80" ] && [ "$PORT" != "http" ]; then
  echo "FAIL: Service port is '$PORT' (expected: '80')."
  exit 1
fi

if [ "$TARGET_PORT" != "80" ] && [ "$TARGET_PORT" != "http" ]; then
  echo "FAIL: Service targetPort is '$TARGET_PORT' (expected: '80')."
  exit 1
fi

# Check selector app=backend-app
SELECTOR=$(kubectl --context="$CONTEXT" get service "$SVC" -o jsonpath='{.spec.selector.app}' 2>/dev/null || echo "")
if [ "$SELECTOR" != "backend-app" ]; then
  echo "FAIL: Service selector 'app' is '$SELECTOR' (expected: 'backend-app')."
  exit 1
fi

# Check endpoints exist
ENDPOINTS=$(kubectl --context="$CONTEXT" get endpoints "$SVC" -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null || echo "")
if [ -z "$ENDPOINTS" ]; then
  echo "FAIL: Service '$SVC' does not target any active backend Pods (endpoints are empty). Make sure backend Pods are running."
  exit 1
fi

echo "PASS: ClusterIP service created and targets backend pods successfully!"
exit 0
