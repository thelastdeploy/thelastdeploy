#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Migrates LVM Storage Online
# Lab: lnx-migrate-lvm-storage
# ==============================================================================

# Step 1: Ensure mig-test directory exists
student_exec \
  --step-name "Ensure mig-test directory exists" \
  --cmd "mkdir -p ~/mig-test" \
  --expect-exit-code 0

# Step 2: Write migration summary line
student_exec \
  --step-name "Write pvmove migration summary" \
  --cmd "echo 'PVMOVE_MIGRATION_VERIFIED' > ~/mig-test/pvmove_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of pvmove_info.txt
student_exec \
  --step-name "Verify pvmove_info.txt content" \
  --cmd "cat ~/mig-test/pvmove_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PVMOVE_MIGRATION_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: LVM storage migration verified."
