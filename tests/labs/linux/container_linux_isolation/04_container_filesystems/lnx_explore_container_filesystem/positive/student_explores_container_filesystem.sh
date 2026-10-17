#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Explores Container Filesystem Abstractions
# Lab: lnx-explore-container-filesystem
# ==============================================================================

# Step 1: Ensure container-fs-test directory exists
student_exec \
  --step-name "Ensure container-fs-test directory exists" \
  --cmd "mkdir -p ~/container-fs-test" \
  --expect-exit-code 0

# Step 2: Inspect root filesystem entries
student_exec \
  --step-name "Inspect root filesystem entries" \
  --cmd "ls -la / 2>/dev/null | head -n 10" \
  --expect-exit-code 0

# Step 3: Write container rootfs exploration marker
student_exec \
  --step-name "Write container rootfs exploration marker" \
  --cmd "echo 'CONTAINER_ROOTFS_EXPLORED' > ~/container-fs-test/rootfs_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify rootfs_summary.txt content
student_exec \
  --step-name "Verify rootfs_summary.txt content" \
  --cmd "cat ~/container-fs-test/rootfs_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CONTAINER_ROOTFS_EXPLORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container filesystem abstraction exploration verified."
