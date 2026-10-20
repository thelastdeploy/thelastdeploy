#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Mount Secret as Volume
# Module: k8s-configuration-storage
# Section: 02-secrets
# Lab ID: k8s-use-secret
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-use-secret"

# Step 1: Student creates secret-explorer pod mounting db-secret at /etc/db
student_exec "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-explorer
spec:
  volumes:
  - name: secret-vol
    secret:
      secretName: db-secret
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: secret-vol
      mountPath: /etc/db
      readOnly: true
EOF" \
    --desc "Student creates secret-explorer pod with mounted secret volume" \
    --expect-exit 0

# Step 2: Student waits for pod readiness
student_exec "kubectl wait --for=condition=Ready pod/secret-explorer --timeout=60s" \
    --desc "Student waits for secret-explorer pod to be ready" \
    --expect-exit 0

# Step 3: Student verifies secret file content inside pod
student_exec "kubectl exec secret-explorer -- cat /etc/db/password" \
    --desc "Student inspects /etc/db/password inside secret-explorer" \
    --expect-exit 0 \
    --expect-stdout "supersecret"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Secret volume mount verified successfully!"
