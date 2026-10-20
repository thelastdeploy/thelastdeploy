#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create an Ingress Resource
# Module: k8s-services-networking
# Section: 05-ingress
# Lab ID: k8s-create-ingress
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-ingress"

# Step 1: Student writes Ingress manifest
student_exec "cat <<EOF > ~/k8s-services-networking/app-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 80
EOF" \
    --desc "Student creates app-ingress.yaml manifest" \
    --expect-exit 0

# Step 2: Student applies Ingress manifest
student_exec "kubectl apply -f ~/k8s-services-networking/app-ingress.yaml" \
    --desc "Student applies app-ingress" \
    --expect-exit 0

# Step 3: Student verifies Ingress resource
student_exec "kubectl get ingress app-ingress" \
    --desc "Student inspects app-ingress" \
    --expect-exit 0 \
    --expect-stdout "app.local"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Ingress resource created and configured correctly!"
