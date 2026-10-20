#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Mount PVC in Pod
# Module: k8s-configuration-storage
# Section: 04-persistent-storage
# Lab ID: k8s-mount-persistent-volume
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-mount-persistent-volume"

# Step 1: Student creates pv-pod mounting task-pv-claim
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      volumeMounts:
        - mountPath: '/usr/share/nginx/html'
          name: task-pv-storage
EOF" \
    --desc "Student creates pv-pod mounting task-pv-claim" \
    --expect-exit 0

# Step 2: Student waits for pod readiness
student_exec "kubectl wait --for=condition=Ready pod/pv-pod --timeout=60s" \
    --desc "Student waits for pv-pod to be ready" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: PVC dynamic storage volume mount successfully verified!"
