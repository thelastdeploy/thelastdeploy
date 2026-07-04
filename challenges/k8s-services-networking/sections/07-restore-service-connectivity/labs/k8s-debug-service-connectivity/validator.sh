#!/bin/bash
# validator.sh — k8s-services-networking / 07-restore-service-connectivity / k8s-debug-service-connectivity
set -euo pipefail

CONTEXT="kind-tld-k8s-debug-service-connectivity"
SVC="api-service"

# Check if Service exists
if ! kubectl --context="$CONTEXT" get service "$SVC" &>/dev/null; then
  echo "FAIL: Service '$SVC' not found."
  exit 1
fi

# Verify selector app=api-server
SELECTOR=$(kubectl --context="$CONTEXT" get service "$SVC" -o jsonpath='{.spec.selector.app}' 2>/dev/null || echo "")
if [ "$SELECTOR" != "api-server" ]; then
  echo "FAIL: Service selector 'app' is '$SELECTOR' (expected: 'api-server')."
  exit 1
fi

# Verify targetPort is 80
TARGET_PORT=$(kubectl --context="$CONTEXT" get service "$SVC" -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null || echo "")
if [ "$TARGET_PORT" != "80" ] && [ "$TARGET_PORT" != "http" ]; then
  echo "FAIL: Service targetPort is '$TARGET_PORT' (expected: '80')."
  exit 1
fi

# Verify endpoints exist
ENDPOINTS=$(kubectl --context="$CONTEXT" get endpoints "$SVC" -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null || echo "")
if [ -z "$ENDPOINTS" ]; then
  echo "FAIL: Service '$SVC' endpoints are empty. Did you fix the selector and make sure the api-pod is running?"
  exit 1
fi

echo "PASS: Service connectivity restored successfully!"
exit 0
