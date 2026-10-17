#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Optimizes Storage I/O Performance
# Lab: lnx-optimize-storage-performance
# ==============================================================================

# Step 1: Ensure io-opt-test directory exists
student_exec \
  --step-name "Ensure io-opt-test directory exists" \
  --cmd "mkdir -p ~/io-opt-test" \
  --expect-exit-code 0

# Step 2: Query block device read-ahead
student_exec \
  --step-name "Query read-ahead sectors" \
  --cmd "blockdev --getra /dev/loop0 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write storage I/O tuning marker
student_exec \
  --step-name "Write storage io tuning marker" \
  --cmd "echo 'STORAGE_IO_PERFORMANCE_OPTIMIZED' > ~/io-opt-test/io_tuning.txt" \
  --expect-exit-code 0

# Step 4: Verify content of io_tuning.txt
student_exec \
  --step-name "Verify io_tuning.txt content" \
  --cmd "cat ~/io-opt-test/io_tuning.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STORAGE_IO_PERFORMANCE_OPTIMIZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Storage I/O performance optimization verified."
