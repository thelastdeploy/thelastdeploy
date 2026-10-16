#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Check your active IP address
# Module: linux-networking
# Section: 02-ip-addresses-and-interfaces
# Lab ID: lnx-check-ip-address
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-check-ip-address"

# Step 1: Student checks IP addresses across network interfaces
student_exec "ip addr" \
    --desc "Student inspects network interfaces and assigned IPs" \
    --expect-exit 0

# Step 2: Student isolates primary IPv4 address and saves to ip_address.txt
student_exec "mkdir -p ~/network-test && (ip -o -4 addr show scope global | awk '{print \$4}' | cut -d/ -f1 | head -n 1 || hostname -I | awk '{print \$1}') > ~/network-test/ip_address.txt" \
    --desc "Student extracts and saves active IPv4 address" \
    --expect-exit 0

# Step 3: Student verifies recorded IP address
student_exec "cat ~/network-test/ip_address.txt" \
    --desc "Student verifies recorded IP address" \
    --expect-exit 0

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Active IP address verified successfully."
