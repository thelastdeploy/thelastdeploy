#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers LVM Storage
# Lab: lnx-recover-lvm-storage
# ==============================================================================

# Step 1: Ensure lvm-diag directory exists
student_exec \
  --step-name "Ensure lvm-diag directory exists" \
  --cmd "mkdir -p ~/lvm-diag" \
  --expect-exit-code 0

# Step 2: Write recovery summary line
student_exec \
  --step-name "Write recovery summary" \
  --cmd "echo 'VGCFGRESTORE_RECOVERY_VERIFIED' > ~/lvm-diag/recovery_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of recovery_summary.txt
student_exec \
  --step-name "Verify recovery_summary.txt content" \
  --cmd "cat ~/lvm-diag/recovery_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "VGCFGRESTORE_RECOVERY_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: LVM metadata recovery verified."
