#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Deploy a Sidecar Pod
# Module: k8s-pods
# Section: 04-multi-container-pods
# Lab ID: k8s-sidecar-pod
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-sidecar-pod"

# Step 1: Student writes multi-container pod manifest
student_exec "cat <<'EOF' > multi-container-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  volumes:
  - name: shared-logs
    emptyDir: {}
  containers:
  - name: app
    image: alpine
    command: [\"sh\", \"-c\", \"while true; do echo 'App output' >> /var/log/app.log; sleep 5; done\"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
  - name: sidecar
    image: alpine
    command: [\"sh\", \"-c\", \"tail -f /var/log/app.log\"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
EOF" \
    --desc "Student authors declarative multi-container manifest with shared volume" \
    --expect-exit 0

# Step 2: Student applies the manifest
student_exec "kubectl apply -f multi-container-pod.yaml" \
    --desc "Student creates multi-container pod" \
    --expect-exit 0

# Step 3: Student waits for pod readiness
student_exec "kubectl wait --for=condition=Ready pod/multi-container-pod --timeout=60s" \
    --desc "Student waits for pod to enter Running state" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Multi-container sidecar pod successfully verified!"
