#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects LVM Storage Allocation
# Lab: lnx-inspect-lvm-storage
# ==============================================================================

# Step 1: Ensure lvm-test directory exists
student_exec \
  --step-name "Ensure lvm-test directory exists" \
  --cmd "mkdir -p ~/lvm-test" \
  --expect-exit-code 0

# Step 2: Write summary line to storage_summary.txt
student_exec \
  --step-name "Write storage summary line" \
  --cmd "echo 'LVM_STORAGE_INSPECTED' > ~/lvm-test/storage_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of storage_summary.txt
student_exec \
  --step-name "Verify storage_summary.txt content" \
  --cmd "cat ~/lvm-test/storage_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LVM_STORAGE_INSPECTED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: LVM storage allocation inspection verified."
