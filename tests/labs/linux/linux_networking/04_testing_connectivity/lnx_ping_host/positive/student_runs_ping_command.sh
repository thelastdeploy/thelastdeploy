#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Check loopback response with ping
# Module: linux-networking
# Section: 04-testing-connectivity
# Lab ID: lnx-ping-host
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-ping-host"

# Step 1: Student runs ping with count 4
student_exec "ping -c 4 127.0.0.1" \
    --desc "Student pings loopback with 4 packets" \
    --expect-exit 0 \
    --expect-stdout "4 packets transmitted"

# Step 2: Student saves ping command to ping_cmd.txt
student_exec "echo 'ping -c 4 127.0.0.1' > ~/network-test/ping_cmd.txt" \
    --desc "Student records ping command" \
    --expect-exit 0

# Step 3: Student verifies recorded command
student_exec "cat ~/network-test/ping_cmd.txt" \
    --desc "Student checks recorded ping command" \
    --expect-exit 0 \
    --expect-stdout "ping -c 4 127.0.0.1"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Ping command syntax verified."
