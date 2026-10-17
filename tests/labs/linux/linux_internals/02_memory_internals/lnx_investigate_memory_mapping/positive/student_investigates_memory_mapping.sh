#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Shared Memory and Anonymous Mappings
# Lab: lnx-investigate-memory-mapping
# ==============================================================================

# Step 1: Ensure mem-internals-test directory exists
student_exec \
  --step-name "Ensure mem-internals-test directory exists" \
  --cmd "mkdir -p ~/mem-internals-test" \
  --expect-exit-code 0

# Step 2: Inspect smaps
student_exec \
  --step-name "Inspect process smaps" \
  --cmd "cat /proc/self/smaps | head -n 15" \
  --expect-exit-code 0

# Step 3: Write smaps investigation marker
student_exec \
  --step-name "Write smaps summary marker" \
  --cmd "echo 'SMAPS_MAPPINGS_INVESTIGATED' > ~/mem-internals-test/smaps_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of smaps_summary.txt
student_exec \
  --step-name "Verify smaps_summary.txt content" \
  --cmd "cat ~/mem-internals-test/smaps_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SMAPS_MAPPINGS_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Shared memory and anonymous mapping investigation verified."
