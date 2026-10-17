#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Virtual Memory Mappings
# Lab: lnx-investigate-virtual-memory
# ==============================================================================

# Step 1: Ensure mem-internals directory exists
student_exec \
  --step-name "Ensure mem-internals directory exists" \
  --cmd "mkdir -p ~/mem-internals" \
  --expect-exit-code 0

# Step 2: Inspect virtual memory maps
student_exec \
  --step-name "Inspect process maps" \
  --cmd "head -n 15 /proc/self/maps" \
  --expect-exit-code 0

# Step 3: Write virtual memory analysis marker
student_exec \
  --step-name "Write vma analysis marker" \
  --cmd "echo 'VIRTUAL_MEMORY_ADDRESS_MAPPINGS_ANALYZED' > ~/mem-internals/vma_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of vma_analysis.txt
student_exec \
  --step-name "Verify vma_analysis.txt content" \
  --cmd "cat ~/mem-internals/vma_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "VIRTUAL_MEMORY_ADDRESS_MAPPINGS_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Virtual Memory Mappings verified successfully."
