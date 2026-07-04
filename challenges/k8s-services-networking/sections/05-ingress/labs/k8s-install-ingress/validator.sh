#!/bin/bash
# validator.sh — k8s-services-networking / 05-ingress / k8s-install-ingress
set -euo pipefail

CONTEXT="kind-tld-k8s-install-ingress"
NS="ingress-nginx"
DEPLOY="ingress-nginx-controller"

# Check if namespace exists
if ! kubectl --context="$CONTEXT" get namespace "$NS" &>/dev/null; then
  echo "FAIL: Namespace '$NS' not found. Did you apply the manifest?"
  exit 1
fi

# Check if deployment exists in namespace
if ! kubectl --context="$CONTEXT" get deployment "$DEPLOY" -n "$NS" &>/dev/null; then
  echo "FAIL: Deployment '$DEPLOY' not found in namespace '$NS'."
  exit 1
fi

# Check for ready replicas
READY=$(kubectl --context="$CONTEXT" get deployment "$DEPLOY" -n "$NS" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

if [ -z "$READY" ] || [ "$READY" -lt 1 ]; then
  echo "FAIL: Ingress controller deployment '$DEPLOY' has no ready replicas yet."
  exit 1
fi

echo "PASS: Ingress controller installed and running successfully!"
exit 0
