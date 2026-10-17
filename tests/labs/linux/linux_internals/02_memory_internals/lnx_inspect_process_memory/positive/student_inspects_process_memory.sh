#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Process Memory Layout
# Lab: lnx-inspect-process-memory
# ==============================================================================

# Step 1: Ensure mem-internals-test directory exists
student_exec \
  --step-name "Ensure mem-internals-test directory exists" \
  --cmd "mkdir -p ~/mem-internals-test" \
  --expect-exit-code 0

# Step 2: Inspect process memory map in /proc
student_exec \
  --step-name "Inspect memory maps via /proc/self/maps" \
  --cmd "cat /proc/self/maps | head -n 10" \
  --expect-exit-code 0

# Step 3: Write memory layout marker
student_exec \
  --step-name "Write memory layout marker" \
  --cmd "echo 'PROCESS_MEMORY_LAYOUT_INSPECTED' > ~/mem-internals-test/memory_layout.txt" \
  --expect-exit-code 0

# Step 4: Verify content of memory_layout.txt
student_exec \
  --step-name "Verify memory_layout.txt content" \
  --cmd "cat ~/mem-internals-test/memory_layout.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_MEMORY_LAYOUT_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Process memory layout inspection verified."
