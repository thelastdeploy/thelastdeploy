#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify the listening process ID
# Module: linux-networking
# Section: 03-ports-and-sockets
# Lab ID: lnx-identify-listening-process
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-listening-process"

# Step 1: Student checks listening sockets or queries process list
student_exec "pgrep -f 'http.server 9876'" \
    --desc "Student finds PID of process listening on port 9876" \
    --expect-exit 0

# Step 2: Student saves PID to listening_pid.txt
student_exec "mkdir -p ~/network-test && pgrep -f 'http.server 9876' | head -n 1 > ~/network-test/listening_pid.txt" \
    --desc "Student saves listening process PID" \
    --expect-exit 0

# Step 3: Student verifies recorded PID
student_exec "cat ~/network-test/listening_pid.txt" \
    --desc "Student verifies recorded PID value" \
    --expect-exit 0

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Listening Process ID successfully identified."
