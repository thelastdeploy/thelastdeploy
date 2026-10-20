#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create transient emptyDir Volume
# Module: k8s-configuration-storage
# Section: 03-volumes
# Lab ID: k8s-emptydir-volume
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-emptydir-volume"

# Step 1: Student creates pod with emptyDir volume mounted at /tmp/data
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: temp-data-pod
spec:
  volumes:
  - name: temp-storage
    emptyDir: {}
  containers:
  - name: main
    image: nginx
    volumeMounts:
    - name: temp-storage
      mountPath: /tmp/data
EOF" \
    --desc "Student creates temp-data-pod with emptyDir volume" \
    --expect-exit 0

# Step 2: Student waits for pod readiness
student_exec "kubectl wait --for=condition=Ready pod/temp-data-pod --timeout=60s" \
    --desc "Student waits for temp-data-pod to be ready" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Transient emptyDir volume successfully verified!"
