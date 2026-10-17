#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Storage I/O Workload Patterns
# Lab: lnx-analyze-io-workload
# ==============================================================================

# Step 1: Ensure io-opt-test directory exists
student_exec \
  --step-name "Ensure io-opt-test directory exists" \
  --cmd "mkdir -p ~/io-opt-test" \
  --expect-exit-code 0

# Step 2: Inspect block device info
student_exec \
  --step-name "Inspect block devices via lsblk" \
  --cmd "lsblk" \
  --expect-exit-code 0

# Step 3: Write storage I/O workload analysis marker
student_exec \
  --step-name "Write storage io profile marker" \
  --cmd "echo 'STORAGE_IO_WORKLOAD_ANALYZED' > ~/io-opt-test/io_profile.txt" \
  --expect-exit-code 0

# Step 4: Verify content of io_profile.txt
student_exec \
  --step-name "Verify io_profile.txt content" \
  --cmd "cat ~/io-opt-test/io_profile.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STORAGE_IO_WORKLOAD_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Storage I/O workload patterns analysis verified."
