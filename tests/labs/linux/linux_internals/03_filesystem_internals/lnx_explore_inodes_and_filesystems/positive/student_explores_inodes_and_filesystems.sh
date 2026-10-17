#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Explores Inodes and Filesystem Metadata
# Lab: lnx-explore-inodes-and-filesystems
# ==============================================================================

# Step 1: Ensure vfs-test directory exists
student_exec \
  --step-name "Ensure vfs-test directory exists" \
  --cmd "mkdir -p ~/vfs-test" \
  --expect-exit-code 0

# Step 2: Inspect file inode metadata
student_exec \
  --step-name "Inspect inode stats via stat" \
  --cmd "stat /etc/passwd" \
  --expect-exit-code 0

# Step 3: Write inode report marker
student_exec \
  --step-name "Write inode report marker" \
  --cmd "echo 'INODE_METADATA_EXPLORED' > ~/vfs-test/inode_report.txt" \
  --expect-exit-code 0

# Step 4: Verify content of inode_report.txt
student_exec \
  --step-name "Verify inode_report.txt content" \
  --cmd "cat ~/vfs-test/inode_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INODE_METADATA_EXPLORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Inodes and filesystem metadata exploration verified."
