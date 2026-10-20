#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Shared Volume
# Module: k8s-configuration-storage
# Section: 03-volumes
# Lab ID: k8s-shared-volume
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-shared-volume"

# Step 1: Student creates sharing-pod with writer and reader containers
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sharing-pod
spec:
  volumes:
  - name: shared-storage
    emptyDir: {}
  containers:
  - name: writer
    image: busybox
    command: [\"sh\", \"-c\", \"echo 'hello from shared volume' > /shared/message.txt && sleep 3600\"]
    volumeMounts:
    - name: shared-storage
      mountPath: /shared
  - name: reader
    image: busybox
    command: [\"sh\", \"-c\", \"sleep 3600\"]
    volumeMounts:
    - name: shared-storage
      mountPath: /shared
EOF" \
    --desc "Student creates sharing-pod multi-container pod" \
    --expect-exit 0

# Step 2: Student waits for pod readiness
student_exec "kubectl wait --for=condition=Ready pod/sharing-pod --timeout=60s" \
    --desc "Student waits for sharing-pod to be ready" \
    --expect-exit 0

# Step 3: Student verifies message in reader container
student_exec "kubectl exec sharing-pod -c reader -- cat /shared/message.txt" \
    --desc "Student reads shared file from reader container" \
    --expect-exit 0 \
    --expect-stdout "hello from shared volume"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Multi-container emptyDir shared volume successfully verified!"
