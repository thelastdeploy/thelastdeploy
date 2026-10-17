#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Network Isolation Issues
# Lab: lnx-investigate-network-isolation
# ==============================================================================

# Step 1: Ensure net-inv-test directory exists
student_exec \
  --step-name "Ensure net-inv-test directory exists" \
  --cmd "mkdir -p ~/net-inv-test" \
  --expect-exit-code 0

# Step 2: Write diagnostic investigation report
student_exec \
  --step-name "Write diagnosis report" \
  --cmd "echo 'ISOLATION_CHECK: ALL_LAYERS_HEALTHY' > ~/net-inv-test/diag_report.txt" \
  --expect-exit-code 0

# Step 3: Verify content of diag_report.txt
student_exec \
  --step-name "Verify diag_report.txt content" \
  --cmd "cat ~/net-inv-test/diag_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ISOLATION_CHECK: ALL_LAYERS_HEALTHY"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network isolation investigation verified."
