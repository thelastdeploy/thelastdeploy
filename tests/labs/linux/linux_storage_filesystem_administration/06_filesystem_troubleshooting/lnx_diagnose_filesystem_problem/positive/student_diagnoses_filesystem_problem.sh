#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Diagnoses Filesystem Problem
# Lab: lnx-diagnose-filesystem-problem
# ==============================================================================

# Step 1: Verify broken_app environment and inspect diagnostic issue
student_exec \
  --step-name "Inspect diagnostic issue" \
  --cmd "cat ~/storage-test/broken_app/diag/issue.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "REASON:"

# Step 2: Create the missing mount target directory
student_exec \
  --step-name "Create missing mount directory" \
  --cmd "mkdir -p ~/storage-test/broken_app/mnt_missing_data" \
  --expect-exit-code 0

# Step 3: Update mock fstab to point to the created directory
student_exec \
  --step-name "Update mount path in fstab_mock" \
  --cmd "sed -i \"s|/mnt/missing_data|\$HOME/storage-test/broken_app/mnt_missing_data|\" ~/storage-test/broken_app/fstab_mock" \
  --expect-exit-code 0

# Step 4: Verify fstab_mock updated configuration
student_exec \
  --step-name "Verify fstab_mock contents" \
  --cmd "cat ~/storage-test/broken_app/fstab_mock" \
  --expect-exit-code 0 \
  --expect-stdout-contains "mnt_missing_data"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Storage mount point diagnosed and fstab_mock repaired."
