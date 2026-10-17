#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Failed Boot Configuration
# Lab: lnx-investigate-failed-boot
# ==============================================================================

# Step 1: Ensure boot-fail-test directory exists with sample fstab.broken if missing
student_exec \
  --step-name "Ensure sample fstab.broken exists" \
  --cmd "mkdir -p ~/boot-fail-test && [ -f ~/boot-fail-test/fstab.broken ] || echo 'UUID=ffff-ffff /data ext4 defaults 0 2' > ~/boot-fail-test/fstab.broken" \
  --expect-exit-code 0

# Step 2: Write diagnosis line to diag_report.txt
student_exec \
  --step-name "Write diagnosis report" \
  --cmd "echo 'BOOT_FAIL_REASON: invalid_fstab_uuid' > ~/boot-fail-test/diag_report.txt" \
  --expect-exit-code 0

# Step 3: Verify content of diag_report.txt
student_exec \
  --step-name "Verify diag_report.txt content" \
  --cmd "cat ~/boot-fail-test/diag_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BOOT_FAIL_REASON: invalid_fstab_uuid"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Failed boot configuration investigation verified."
