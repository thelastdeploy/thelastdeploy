#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Debug Service Connectivity
# Module: k8s-services-networking
# Section: 07-restore-service-connectivity
# Lab ID: k8s-debug-service-connectivity
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-debug-service-connectivity"

# Step 1: Student writes corrected api-service manifest
student_exec "cat <<EOF > ~/k8s-services-networking/api-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api-server
  ports:
  - port: 80
    targetPort: 80
EOF" \
    --desc "Student writes corrected api-service.yaml manifest" \
    --expect-exit 0

# Step 2: Student applies corrected manifest
student_exec "kubectl apply -f ~/k8s-services-networking/api-service.yaml" \
    --desc "Student applies corrected api-service manifest" \
    --expect-exit 0

# Step 3: Student verifies endpoints exist for api-service
student_exec "kubectl get endpoints api-service" \
    --desc "Student verifies api-service endpoints" \
    --expect-exit 0 \
    --expect-stdout "80"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Service connectivity restored successfully!"
