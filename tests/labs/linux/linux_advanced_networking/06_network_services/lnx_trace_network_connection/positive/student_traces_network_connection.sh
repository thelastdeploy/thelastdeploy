#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Network Connection Flow
# Lab: lnx-trace-network-connection
# ==============================================================================

# Step 1: Ensure svc-net-test directory exists
student_exec \
  --step-name "Ensure svc-net-test directory exists" \
  --cmd "mkdir -p ~/svc-net-test" \
  --expect-exit-code 0

# Step 2: Write packet tracing summary
student_exec \
  --step-name "Write packet trace summary" \
  --cmd "echo 'PACKET_TRACE_VERIFIED' > ~/svc-net-test/trace_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of trace_summary.txt
student_exec \
  --step-name "Verify trace_summary.txt content" \
  --cmd "cat ~/svc-net-test/trace_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PACKET_TRACE_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network connection flow tracing verified."
