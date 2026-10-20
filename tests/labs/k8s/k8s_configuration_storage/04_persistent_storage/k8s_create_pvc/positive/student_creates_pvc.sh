#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Storage Claim
# Module: k8s-configuration-storage
# Section: 04-persistent-storage
# Lab ID: k8s-create-pvc
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-create-pvc"

# Step 1: Student creates task-pv-claim PersistentVolumeClaim
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF" \
    --desc "Student creates task-pv-claim PVC" \
    --expect-exit 0

# Step 2: Student verifies PVC exists
student_exec "kubectl get pvc task-pv-claim" \
    --desc "Student inspects task-pv-claim" \
    --expect-exit 0 \
    --expect-stdout "task-pv-claim"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: PersistentVolumeClaim 'task-pv-claim' successfully verified!"
