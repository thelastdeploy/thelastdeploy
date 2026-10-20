#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Pod Storage Mount
# Module: k8s-configuration-storage
# Section: 06-recover-a-stateful-application
# Lab ID: k8s-fix-storage-configuration
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-fix-storage-configuration"

# Step 1: Student creates missing PersistentVolumeClaim non-existent-claim
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: non-existent-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF" \
    --desc "Student creates missing non-existent-claim PVC" \
    --expect-exit 0

# Step 2: Student waits for db-pod to become ready and running
student_exec "kubectl wait --for=condition=Ready pod/db-pod --timeout=60s" \
    --desc "Student waits for db-pod to reach ready state" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Storage configuration fixed and db-pod successfully mounted and running!"
