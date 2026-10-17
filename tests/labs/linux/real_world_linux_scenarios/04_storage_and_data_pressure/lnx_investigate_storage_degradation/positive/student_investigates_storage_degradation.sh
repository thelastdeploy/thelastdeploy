#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Storage Performance Degradation
# Lab: lnx-investigate-storage-degradation
# ==============================================================================

# Step 1: Ensure storage-crisis directory exists
student_exec \
  --step-name "Ensure storage-crisis directory exists" \
  --cmd "mkdir -p ~/storage-crisis" \
  --expect-exit-code 0

# Step 2: Check storage metrics and mount options
student_exec \
  --step-name "Check storage metrics and mount options" \
  --cmd "mount | head -n 5 && df -h" \
  --expect-exit-code 0

# Step 3: Write storage degradation marker
student_exec \
  --step-name "Write storage degradation marker" \
  --cmd "echo 'STORAGE_IO_DEGRADATION_DIAGNOSED_AND_TUNED' > ~/storage-crisis/storage_degradation.txt" \
  --expect-exit-code 0

# Step 4: Verify degradation file content
student_exec \
  --step-name "Verify degradation file content" \
  --cmd "cat ~/storage-crisis/storage_degradation.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STORAGE_IO_DEGRADATION_DIAGNOSED_AND_TUNED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Storage Performance Degradation verified successfully."
