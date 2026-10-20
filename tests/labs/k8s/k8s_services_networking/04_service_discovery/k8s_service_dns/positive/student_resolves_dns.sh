#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Resolve Service DNS
# Module: k8s-services-networking
# Section: 04-service-discovery
# Lab ID: k8s-service-dns
# ==============================================================================
set -euo pipefail

LAB_ID="k8s-service-dns"

# Step 1: Student resolves backend-service DNS via nslookup from client-pod
student_exec "kubectl exec client-pod -- nslookup backend-service > ~/k8s-services-networking/dns-resolve.txt || true" \
    --desc "Student resolves backend-service DNS inside client-pod" \
    --expect-exit 0

# Step 2: Student verifies dns-resolve.txt contains backend-service
student_exec "grep 'backend-service' ~/k8s-services-networking/dns-resolve.txt" \
    --desc "Student inspects dns-resolve.txt" \
    --expect-exit 0 \
    --expect-stdout "backend-service"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Service DNS successfully resolved and verified!"
