#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Diagnoses LVM Problems
# Lab: lnx-diagnose-lvm-problem
# ==============================================================================

# Step 1: Ensure lvm-diag directory exists
student_exec \
  --step-name "Ensure lvm-diag directory exists" \
  --cmd "mkdir -p ~/lvm-diag" \
  --expect-exit-code 0

# Step 2: Write diagnostic completion line
student_exec \
  --step-name "Write diagnostics report" \
  --cmd "echo 'LVM_DIAGNOSTICS_COMPLETED' > ~/lvm-diag/diag_report.txt" \
  --expect-exit-code 0

# Step 3: Verify content of diag_report.txt
student_exec \
  --step-name "Verify diag_report.txt content" \
  --cmd "cat ~/lvm-diag/diag_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LVM_DIAGNOSTICS_COMPLETED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: LVM diagnostics verified."
