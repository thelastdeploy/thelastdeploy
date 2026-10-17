#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Kernel File Operations
# Lab: lnx-trace-kernel-file-operations
# ==============================================================================

# Step 1: Ensure vfs-internals directory exists
student_exec \
  --step-name "Ensure vfs-internals directory exists" \
  --cmd "mkdir -p ~/vfs-internals" \
  --expect-exit-code 0

# Step 2: Inspect dentry and inode state
student_exec \
  --step-name "Inspect dentry and inode state" \
  --cmd "cat /proc/sys/fs/dentry-state" \
  --expect-exit-code 0

# Step 3: Write file operations trace marker
student_exec \
  --step-name "Write file operations marker" \
  --cmd "echo 'KERNEL_FILE_OPERATIONS_AND_CACHE_TRACED' > ~/vfs-internals/file_ops.log" \
  --expect-exit-code 0

# Step 4: Verify content of file_ops.log
student_exec \
  --step-name "Verify file_ops.log content" \
  --cmd "cat ~/vfs-internals/file_ops.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_FILE_OPERATIONS_AND_CACHE_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Trace Kernel File Operations verified successfully."
