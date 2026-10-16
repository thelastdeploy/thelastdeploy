#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Superblock Metadata and Filesystem Health
# Lab: lnx-inspect-filesystem-health
# ==============================================================================

# Step 1: Ensure storage-test directory exists
student_exec \
  --step-name "Ensure storage-test directory exists" \
  --cmd "mkdir -p ~/storage-test" \
  --expect-exit-code 0

# Step 2: Query superblock metadata or copy simulated tune2fs dump to fs_health.txt
student_exec \
  --step-name "Save filesystem health metadata" \
  --cmd "if [ -f ~/storage-test/tune2fs_output.txt ]; then
  cp ~/storage-test/tune2fs_output.txt ~/storage-test/fs_health.txt
else
  tune2fs -l /dev/sda1 > ~/storage-test/fs_health.txt 2>/dev/null || true
fi" \
  --expect-exit-code 0

# Step 3: Verify fs_health.txt content
student_exec \
  --step-name "Verify fs_health.txt content" \
  --cmd "cat ~/storage-test/fs_health.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "clean"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Filesystem health metadata inspection verified."
