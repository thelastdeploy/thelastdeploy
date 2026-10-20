#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Use ConfigMap as Env Var
# Module: k8s-configuration-storage
# Section: 01-configmaps
# Lab ID: k8s-use-configmap
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-use-configmap"

# Step 1: Student creates pod consuming ConfigMap key as APP_ENV
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-explorer
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: APP_ENV
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: app.environment
EOF" \
    --desc "Student creates config-explorer pod with APP_ENV" \
    --expect-exit 0

# Step 2: Student waits for pod to be ready
student_exec "kubectl wait --for=condition=Ready pod/config-explorer --timeout=60s" \
    --desc "Student waits for config-explorer pod to be ready" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: ConfigMap environment variable injection verified successfully!"
