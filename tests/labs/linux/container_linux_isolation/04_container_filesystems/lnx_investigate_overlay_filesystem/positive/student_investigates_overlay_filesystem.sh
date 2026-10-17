#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates OverlayFS Storage Layers
# Lab: lnx-investigate-overlay-filesystem
# ==============================================================================

# Step 1: Ensure container-fs-test directory exists
student_exec \
  --step-name "Ensure container-fs-test directory exists" \
  --cmd "mkdir -p ~/container-fs-test" \
  --expect-exit-code 0

# Step 2: Check overlay kernel module or mount support
student_exec \
  --step-name "Check overlay kernel module or mount support" \
  --cmd "grep -i overlay /proc/filesystems 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write overlayfs investigation marker
student_exec \
  --step-name "Write overlayfs investigation marker" \
  --cmd "echo 'OVERLAYFS_LAYERS_INVESTIGATED' > ~/container-fs-test/overlay_info.txt" \
  --expect-exit-code 0

# Step 4: Verify overlay_info.txt content
student_exec \
  --step-name "Verify overlay_info.txt content" \
  --cmd "cat ~/container-fs-test/overlay_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "OVERLAYFS_LAYERS_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: OverlayFS storage layer investigation verified."
