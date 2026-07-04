#!/bin/bash
# validator.sh — k8s-services-networking / 06-network-policies / k8s-restrict-traffic
set -euo pipefail

CONTEXT="kind-tld-k8s-restrict-traffic"
POLICY="db-policy"

# Check if NetworkPolicy exists
if ! kubectl --context="$CONTEXT" get networkpolicy "$POLICY" &>/dev/null; then
  echo "FAIL: NetworkPolicy '$POLICY' not found. Please create it."
  exit 1
fi

# Verify policy selects pods with label role=db
TARGET_SELECTOR=$(kubectl --context="$CONTEXT" get networkpolicy "$POLICY" -o jsonpath='{.spec.podSelector.matchLabels.role}' 2>/dev/null || echo "")
if [ "$TARGET_SELECTOR" != "db" ]; then
  echo "FAIL: NetworkPolicy targets pods with label role='$TARGET_SELECTOR' (expected: 'db')."
  exit 1
fi

# Verify Ingress allows role=backend
ALLOW_SELECTOR=$(kubectl --context="$CONTEXT" get networkpolicy "$POLICY" -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.role}' 2>/dev/null || echo "")
if [ "$ALLOW_SELECTOR" != "backend" ]; then
  echo "FAIL: NetworkPolicy ingress source does not match pods with label role='$ALLOW_SELECTOR' (expected: 'backend')."
  exit 1
fi

# Verify Ingress policyType exists
TYPE=$(kubectl --context="$CONTEXT" get networkpolicy "$POLICY" -o jsonpath='{.spec.policyTypes[0]}' 2>/dev/null || echo "")
if [ "$TYPE" != "Ingress" ]; then
  echo "FAIL: NetworkPolicy policyType is not set to 'Ingress'."
  exit 1
fi

echo "PASS: NetworkPolicy 'db-policy' restricts traffic correctly!"
exit 0
