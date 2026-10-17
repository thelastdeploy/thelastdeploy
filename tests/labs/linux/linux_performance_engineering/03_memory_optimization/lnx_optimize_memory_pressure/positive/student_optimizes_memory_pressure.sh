#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Optimizes Memory Subsystem Tuneables
# Lab: lnx-optimize-memory-pressure
# ==============================================================================

# Step 1: Ensure mem-opt-test directory exists
student_exec \
  --step-name "Ensure mem-opt-test directory exists" \
  --cmd "mkdir -p ~/mem-opt-test" \
  --expect-exit-code 0

# Step 2: Query sysctl parameters
student_exec \
  --step-name "Query sysctl memory parameters" \
  --cmd "sysctl vm.swappiness vm.dirty_ratio 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write memory optimization marker
student_exec \
  --step-name "Write memory tuning marker" \
  --cmd "echo 'MEMORY_SUBSYSTEM_OPTIMIZED' > ~/mem-opt-test/mem_tuning.txt" \
  --expect-exit-code 0

# Step 4: Verify content of mem_tuning.txt
student_exec \
  --step-name "Verify mem_tuning.txt content" \
  --cmd "cat ~/mem-opt-test/mem_tuning.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "MEMORY_SUBSYSTEM_OPTIMIZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Memory subsystem tuneables optimization verified."
