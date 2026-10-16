#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Query the standard SSH service port
# Module: linux-networking
# Section: 03-ports-and-sockets
# Lab ID: lnx-find-service-port
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-service-port"

# Step 1: Student searches /etc/services for ssh port mapping
student_exec "grep -E '^ssh[[:space:]]' /etc/services" \
    --desc "Student inspects /etc/services for SSH port" \
    --expect-exit 0 \
    --expect-stdout "22/tcp"

# Step 2: Student extracts and saves port 22
student_exec "awk '\$1 == \"ssh\" && \$2 ~ /\\/tcp/ {split(\$2, a, \"/\"); print a[1]}' /etc/services > ~/network-test/ssh_port.txt" \
    --desc "Student saves SSH port number" \
    --expect-exit 0

# Step 3: Student verifies recorded port number
student_exec "cat ~/network-test/ssh_port.txt" \
    --desc "Student verifies recorded port value" \
    --expect-exit 0 \
    --expect-stdout "22"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: SSH service port successfully identified."
