#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Solve complex outage investigation using CLI pipeline
# Module: linux-command-line-tools
# Section: 09-command-line-challenge
# Lab ID: lnx-solve-cli-investigation
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-solve-cli-investigation"

# Step 1: Student lists log files in the incident directory
student_exec "ls -la ~/cli-challenge/logs" \
    --desc "Student inspects log files in ~/cli-challenge/logs" \
    --expect-exit 0 \
    --expect-stdout "node_1.log"

# Step 2: Student streams concatenated logs across all node files
student_exec "cat ~/cli-challenge/logs/*.log" \
    --desc "Student inspects concatenated logs from all nodes" \
    --expect-exit 0 \
    --expect-stdout "/api/v1/auth"

# Step 3: Student filters logs for the targeted /api/v1/auth endpoint
student_exec "cat ~/cli-challenge/logs/*.log | grep '/api/v1/auth'" \
    --desc "Student filters lines matching /api/v1/auth endpoint" \
    --expect-exit 0 \
    --expect-stdout "203.0.113.199"

# Step 4: Student tallies and ranks request frequencies per IP
student_exec "cat ~/cli-challenge/logs/*.log | grep '/api/v1/auth' | awk '{print \$1}' | sort | uniq -c | sort -nr" \
    --desc "Student calculates request counts per IP in descending order" \
    --expect-exit 0 \
    --expect-stdout "4 203.0.113.199"

# Step 5: Student isolates the root cause top offender IP address
student_exec "cat ~/cli-challenge/logs/*.log | grep '/api/v1/auth' | awk '{print \$1}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print \$2}'" \
    --desc "Student isolates the top offender IP address" \
    --expect-exit 0 \
    --expect-stdout "203.0.113.199"

# Step 6: Student saves root cause IP into root_cause_ip.txt
student_exec "cat ~/cli-challenge/logs/*.log | grep '/api/v1/auth' | awk '{print \$1}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print \$2}' > ~/cli-challenge/root_cause_ip.txt" \
    --desc "Student saves root cause IP into ~/cli-challenge/root_cause_ip.txt" \
    --expect-exit 0

# Step 7: Student verifies file content
student_exec "cat ~/cli-challenge/root_cause_ip.txt" \
    --desc "Student verifies the contents of ~/cli-challenge/root_cause_ip.txt" \
    --expect-exit 0 \
    --expect-stdout "203.0.113.199"

# Step 8: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Root cause IP identified correctly via CLI pipeline!"
