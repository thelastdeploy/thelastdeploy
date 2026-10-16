#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Match IPv4 addresses using extended regex
# Module: linux-command-line-tools
# Section: 07-regular-expressions
# Lab ID: lnx-match-log-patterns
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-match-log-patterns"

# Step 1: Student inspects the network log file
student_exec "cat ~/regex-test/network.log" \
    --desc "Student inspects raw network logs" \
    --expect-exit 0 \
    --expect-stdout "10.0.0.1"

# Step 2: Student tests extended regex matching lines with 10.x IP addresses
student_exec "grep -E ' 10\.[0-9]+' ~/regex-test/network.log" \
    --desc "Student matches 10.x IPs using grep -E" \
    --expect-exit 0 \
    --expect-stdout "10.255.0.99"

# Step 3: Student counts the number of matching lines
student_exec "grep -E ' 10\.[0-9]+' ~/regex-test/network.log | wc -l" \
    --desc "Student calculates line count using wc -l" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 4: Student redirects the count into ip_matches.txt
student_exec "grep -E ' 10\.[0-9]+' ~/regex-test/network.log | wc -l > ~/regex-test/ip_matches.txt" \
    --desc "Student saves matching count into ~/regex-test/ip_matches.txt" \
    --expect-exit 0

# Step 5: Student confirms file contents
student_exec "cat ~/regex-test/ip_matches.txt" \
    --desc "Student verifies the contents of ~/regex-test/ip_matches.txt" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Extended regex IP pattern matching verified."
