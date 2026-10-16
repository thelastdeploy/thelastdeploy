#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Filesystem Formats and UUIDs
# Lab: lnx-identify-filesystem-types
# ==============================================================================

# Step 1: Ensure storage-test directory exists
student_exec \
  --step-name "Ensure storage-test directory exists" \
  --cmd "mkdir -p ~/storage-test" \
  --expect-exit-code 0

# Step 2: Query filesystem types or copy simulated blkid dump to fs_summary.txt
student_exec \
  --step-name "Generate filesystem types summary" \
  --cmd "if [ -f ~/storage-test/blkid_output.txt ]; then
  cp ~/storage-test/blkid_output.txt ~/storage-test/fs_summary.txt
else
  blkid > ~/storage-test/fs_summary.txt 2>/dev/null || true
fi" \
  --expect-exit-code 0

# Step 3: Verify fs_summary.txt content
student_exec \
  --step-name "Verify fs_summary.txt content" \
  --cmd "cat ~/storage-test/fs_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ext4"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Filesystem format and UUID identification verified."
