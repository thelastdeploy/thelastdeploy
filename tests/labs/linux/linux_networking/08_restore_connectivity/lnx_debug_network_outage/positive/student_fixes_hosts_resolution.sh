#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Map an internal domain name
# Module: linux-networking
# Section: 08-restore-connectivity
# Lab ID: lnx-debug-network-outage
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-debug-network-outage"

# Step 1: Student checks initial resolution failure
student_exec "getent hosts broken.tld.local || true" \
    --desc "Student observes resolution failure for broken.tld.local" \
    --expect-exit 0

# Step 2: Student inspects /etc/hosts
student_exec "cat /etc/hosts" \
    --desc "Student inspects static hosts table" \
    --expect-exit 0 \
    --expect-stdout "127.0.0.1"

# Step 3: Student maps broken.tld.local to 127.0.0.1 in /etc/hosts
student_exec "echo '127.0.0.1 broken.tld.local broken.devlab.local' >> /etc/hosts" \
    --desc "Student adds static host resolution mapping to /etc/hosts" \
    --expect-exit 0

# Step 4: Student confirms hostname now resolves
student_exec "getent hosts broken.tld.local" \
    --desc "Student verifies hostname resolves to loopback" \
    --expect-exit 0 \
    --expect-stdout "127.0.0.1"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Static hostname resolution correctly configured in /etc/hosts."
