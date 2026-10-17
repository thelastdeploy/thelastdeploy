#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates and Restores LVM Snapshots
# Lab: lnx-create-and-restore-lvm-snapshot
# ==============================================================================

# Step 1: Ensure snap-test directory exists
student_exec \
  --step-name "Ensure snap-test directory exists" \
  --cmd "mkdir -p ~/snap-test" \
  --expect-exit-code 0

# Step 2: Write snapshot procedure summary line
student_exec \
  --step-name "Write snapshot procedure summary" \
  --cmd "echo 'LVM_SNAPSHOT_PROCEDURE_VERIFIED' > ~/snap-test/snap_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of snap_summary.txt
student_exec \
  --step-name "Verify snap_summary.txt content" \
  --cmd "cat ~/snap-test/snap_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LVM_SNAPSHOT_PROCEDURE_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: LVM snapshot procedure verified."
