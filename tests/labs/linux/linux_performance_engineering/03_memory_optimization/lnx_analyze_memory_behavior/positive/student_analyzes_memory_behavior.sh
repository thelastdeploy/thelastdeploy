#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Kernel Memory Allocator Behavior
# Lab: lnx-analyze-memory-behavior
# ==============================================================================

# Step 1: Ensure mem-opt-test directory exists
student_exec \
  --step-name "Ensure mem-opt-test directory exists" \
  --cmd "mkdir -p ~/mem-opt-test" \
  --expect-exit-code 0

# Step 2: Inspect virtual memory sysctl values
student_exec \
  --step-name "Inspect vm sysctl parameters" \
  --cmd "cat /proc/sys/vm/swappiness" \
  --expect-exit-code 0

# Step 3: Write memory behavior analysis marker
student_exec \
  --step-name "Write memory behavior marker" \
  --cmd "echo 'MEMORY_BEHAVIOR_ANALYZED' > ~/mem-opt-test/mem_behavior.txt" \
  --expect-exit-code 0

# Step 4: Verify content of mem_behavior.txt
student_exec \
  --step-name "Verify mem_behavior.txt content" \
  --cmd "cat ~/mem-opt-test/mem_behavior.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "MEMORY_BEHAVIOR_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Kernel memory allocator behavior analysis verified."
