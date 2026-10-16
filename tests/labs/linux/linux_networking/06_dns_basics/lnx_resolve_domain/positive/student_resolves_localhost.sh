#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Resolve a domain name local mapping
# Module: linux-networking
# Section: 06-dns-basics
# Lab ID: lnx-resolve-domain
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-resolve-domain"

# Step 1: Student resolves localhost using getent hosts or /etc/hosts
student_exec "getent hosts localhost" \
    --desc "Student queries host lookup database for localhost" \
    --expect-exit 0 \
    --expect-stdout "127.0.0.1"

# Step 2: Student extracts and saves resolved loopback IP
student_exec "mkdir -p ~/network-test && getent ahostsv4 localhost | awk '{print \$1}' | head -n 1 > ~/network-test/resolved_dns.txt" \
    --desc "Student saves resolved IPv4 address" \
    --expect-exit 0

# Step 3: Student verifies recorded IP
student_exec "cat ~/network-test/resolved_dns.txt" \
    --desc "Student verifies recorded IP value" \
    --expect-exit 0 \
    --expect-stdout "127.0.0.1"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: DNS lookup verified successfully."
