#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Disk Capacity
# Lab: lnx-investigate-disk-capacity
# ==============================================================================

# Step 1: Ensure capacity_audit directory exists
student_exec \
  --step-name "Ensure capacity_audit directory exists" \
  --cmd "ls -d ~/storage-test/capacity_audit" \
  --expect-exit-code 0

# Step 2: Analyze subdirectory disk usage and determine largest directory
student_exec \
  --step-name "Identify and record largest directory" \
  --cmd "LARGEST=\$(du -s ~/storage-test/capacity_audit/* | sort -nr | head -n 1 | awk '{print \$2}')
basename \"\$LARGEST\" > ~/storage-test/largest_dir.txt" \
  --expect-exit-code 0

# Step 3: Verify largest_dir.txt content
student_exec \
  --step-name "Verify recorded largest directory" \
  --cmd "cat ~/storage-test/largest_dir.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "backups"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Largest directory correctly identified."
