#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Extract and count recurring log patterns
# Module: linux-command-line-tools
# Section: 04-text-processing
# Lab ID: lnx-extract-useful-data
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-extract-useful-data"

# Step 1: Student inspects the raw IP log file
student_exec "cat ~/text-test/ips.txt" \
    --desc "Student inspects raw IP logs in ~/text-test/ips.txt" \
    --expect-exit 0 \
    --expect-stdout "192.168.1.50"

# Step 2: Student filters the specific IP address occurrences
student_exec "grep '192.168.1.50' ~/text-test/ips.txt" \
    --desc "Student tests filtering target IP occurrences" \
    --expect-exit 0 \
    --expect-stdout "192.168.1.50"

# Step 3: Student counts matching lines using grep -c
student_exec "grep -c '192.168.1.50' ~/text-test/ips.txt" \
    --desc "Student counts IP occurrences with grep -c" \
    --expect-exit 0 \
    --expect-stdout "4"

# Step 4: Student redirects the count into ip_count.txt
student_exec "grep -c '192.168.1.50' ~/text-test/ips.txt > ~/text-test/ip_count.txt" \
    --desc "Student redirects recurring IP count into ip_count.txt" \
    --expect-exit 0

# Step 5: Student confirms the content of ip_count.txt
student_exec "cat ~/text-test/ip_count.txt" \
    --desc "Student verifies ~/text-test/ip_count.txt" \
    --expect-exit 0 \
    --expect-stdout "4"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Recurring log pattern count extracted successfully."
