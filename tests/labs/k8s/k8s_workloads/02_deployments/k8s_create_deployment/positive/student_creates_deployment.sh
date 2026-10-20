#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Deployment
# Module: k8s-workloads
# Section: 02-deployments
# Lab ID: k8s-create-deployment
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-deployment"

# Step 1: Student creates deployment manifest
student_exec "cat <<'EOF' > nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
EOF" \
    --desc "Student authors declarative deployment manifest" \
    --expect-exit 0

# Step 2: Student applies the deployment manifest
student_exec "kubectl apply -f nginx-deployment.yaml" \
    --desc "Student creates deployment in cluster" \
    --expect-exit 0

# Step 3: Student waits for rollout completion
student_exec "kubectl rollout status deployment/nginx-deployment --timeout=60s" \
    --desc "Student waits for all 3 deployment replicas to be ready" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Deployment 'nginx-deployment' successfully created with 3 running replicas!"
