#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates VFS Abstraction Behavior
# Lab: lnx-investigate-vfs-behavior
# ==============================================================================

# Step 1: Ensure vfs-internals directory exists
student_exec \
  --step-name "Ensure vfs-internals directory exists" \
  --cmd "mkdir -p ~/vfs-internals" \
  --expect-exit-code 0

# Step 2: Inspect file-nr and locks
student_exec \
  --step-name "Inspect file descriptors and locks" \
  --cmd "cat /proc/sys/fs/file-nr" \
  --expect-exit-code 0

# Step 3: Write VFS structures marker
student_exec \
  --step-name "Write VFS structures marker" \
  --cmd "echo 'VFS_FILE_DESCRIPTORS_AND_INODES_INVESTIGATED' > ~/vfs-internals/vfs_structures.log" \
  --expect-exit-code 0

# Step 4: Verify content of vfs_structures.log
student_exec \
  --step-name "Verify vfs_structures.log content" \
  --cmd "cat ~/vfs-internals/vfs_structures.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "VFS_FILE_DESCRIPTORS_AND_INODES_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate VFS Abstraction Behavior verified successfully."
