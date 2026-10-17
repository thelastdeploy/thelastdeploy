#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Memory Management & Page Faults
# Lab: lnx-trace-memory-management
# ==============================================================================

# Step 1: Ensure mem-internals directory exists
student_exec \
  --step-name "Ensure mem-internals directory exists" \
  --cmd "mkdir -p ~/mem-internals" \
  --expect-exit-code 0

# Step 2: Inspect vmstat and slabinfo
student_exec \
  --step-name "Inspect vmstat and slabinfo" \
  --cmd "grep -E '^(pgfault|pgmajfault)' /proc/vmstat" \
  --expect-exit-code 0

# Step 3: Write page faults and slab marker
student_exec \
  --step-name "Write page faults and slab marker" \
  --cmd "echo 'PAGE_FAULTS_AND_SLAB_ALLOCATOR_TRACED' > ~/mem-internals/page_fault_slab.log" \
  --expect-exit-code 0

# Step 4: Verify content of page_fault_slab.log
student_exec \
  --step-name "Verify page_fault_slab.log content" \
  --cmd "cat ~/mem-internals/page_fault_slab.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PAGE_FAULTS_AND_SLAB_ALLOCATOR_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Trace Memory Management & Page Faults verified successfully."
