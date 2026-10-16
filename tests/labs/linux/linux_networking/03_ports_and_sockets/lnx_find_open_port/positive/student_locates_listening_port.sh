#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Locate an active local listener
# Module: linux-networking
# Section: 03-ports-and-sockets
# Lab ID: lnx-find-open-port
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-open-port"

# Step 1: Student inspects listening TCP sockets
student_exec "ss -ltn" \
    --desc "Student inspects listening TCP ports" \
    --expect-exit 0 \
    --expect-stdout "9876"

# Step 2: Student extracts listening port 9876 and saves to open_port.txt
student_exec "mkdir -p ~/network-test && ss -ltn | grep '127.0.0.1:9876' | awk '{print \$4}' | awk -F: '{print \$NF}' > ~/network-test/open_port.txt" \
    --desc "Student extracts and saves listening port" \
    --expect-exit 0

# Step 3: Student verifies recorded port
student_exec "cat ~/network-test/open_port.txt" \
    --desc "Student verifies recorded port value" \
    --expect-exit 0 \
    --expect-stdout "9876"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Active local listener port successfully identified."
