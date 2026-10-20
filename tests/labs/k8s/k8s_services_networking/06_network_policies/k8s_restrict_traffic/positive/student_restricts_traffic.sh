#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Restrict Traffic with NetworkPolicy
# Module: k8s-services-networking
# Section: 06-network-policies
# Lab ID: k8s-restrict-traffic
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-restrict-traffic"

# Step 1: Student writes db-policy manifest
student_exec "cat <<EOF > ~/k8s-services-networking/db-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: backend
EOF" \
    --desc "Student writes db-policy.yaml manifest" \
    --expect-exit 0

# Step 2: Student applies NetworkPolicy manifest
student_exec "kubectl apply -f ~/k8s-services-networking/db-policy.yaml" \
    --desc "Student applies db-policy" \
    --expect-exit 0

# Step 3: Student verifies NetworkPolicy
student_exec "kubectl get networkpolicy db-policy" \
    --desc "Student inspects db-policy" \
    --expect-exit 0 \
    --expect-stdout "db-policy"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: NetworkPolicy 'db-policy' restricts traffic correctly!"
