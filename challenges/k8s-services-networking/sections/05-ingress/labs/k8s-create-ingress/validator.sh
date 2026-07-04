#!/bin/bash
# validator.sh — k8s-services-networking / 05-ingress / k8s-create-ingress
set -euo pipefail

CONTEXT="kind-tld-k8s-create-ingress"
ING="app-ingress"

# Check if Ingress exists
if ! kubectl --context="$CONTEXT" get ingress "$ING" &>/dev/null; then
  echo "FAIL: Ingress resource '$ING' not found. Please create it."
  exit 1
fi

# Verify host is app.local
HOST=$(kubectl --context="$CONTEXT" get ingress "$ING" -o jsonpath='{.spec.rules[0].host}' 2>/dev/null || echo "")
if [ "$HOST" != "app.local" ]; then
  echo "FAIL: Ingress rule host is '$HOST' (expected: 'app.local')."
  exit 1
fi

# Verify it points to backend-service on port 80
SVC_NAME=$(kubectl --context="$CONTEXT" get ingress "$ING" -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null || echo "")
SVC_PORT=$(kubectl --context="$CONTEXT" get ingress "$ING" -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null || echo "")

if [ "$SVC_NAME" != "backend-service" ]; then
  echo "FAIL: Ingress target service name is '$SVC_NAME' (expected: 'backend-service')."
  exit 1
fi

if [ "$SVC_PORT" != "80" ]; then
  echo "FAIL: Ingress target service port is '$SVC_PORT' (expected: '80')."
  exit 1
fi

# Verify ingressClassName is nginx
CLASS=$(kubectl --context="$CONTEXT" get ingress "$ING" -o jsonpath='{.spec.ingressClassName}' 2>/dev/null || echo "")
if [ "$CLASS" != "nginx" ]; then
  echo "FAIL: Ingress 'ingressClassName' is '$CLASS' (expected: 'nginx')."
  exit 1
fi

echo "PASS: Ingress resource created and configured correctly!"
exit 0
