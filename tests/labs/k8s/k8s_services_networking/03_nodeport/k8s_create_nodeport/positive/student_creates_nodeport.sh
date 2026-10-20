#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a NodePort Service
# Module: k8s-services-networking
# Section: 03-nodeport
# Lab ID: k8s-create-nodeport
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-nodeport"

# Step 1: Student creates NodePort service manifest
student_exec "cat <<EOF > ~/k8s-services-networking/nodeport-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
spec:
  type: NodePort
  selector:
    app: backend-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
EOF" \
    --desc "Student writes nodeport-service.yaml" \
    --expect-exit 0

# Step 2: Student applies service manifest
student_exec "kubectl apply -f ~/k8s-services-networking/nodeport-service.yaml" \
    --desc "Student creates nodeport-service" \
    --expect-exit 0

# Step 3: Student verifies service and endpoints
student_exec "kubectl get svc nodeport-service" \
    --desc "Student inspects nodeport-service" \
    --expect-exit 0 \
    --expect-stdout "30080"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: NodePort service created successfully on nodePort 30080!"
