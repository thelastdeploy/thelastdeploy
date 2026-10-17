#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Filesystem on Logical Volume
# Lab: lnx-configure-lvm-filesystem
# ==============================================================================

# Step 1: Ensure lv-test directory exists
student_exec \
  --step-name "Ensure lv-test directory exists" \
  --cmd "mkdir -p ~/lv-test" \
  --expect-exit-code 0

# Step 2: Write summary line to mount_info.txt
student_exec \
  --step-name "Write LV filesystem configuration summary" \
  --cmd "echo 'LV_FILESYSTEM_CONFIGURED' > ~/lv-test/mount_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of mount_info.txt
student_exec \
  --step-name "Verify mount_info.txt content" \
  --cmd "cat ~/lv-test/mount_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LV_FILESYSTEM_CONFIGURED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Logical volume filesystem configuration verified."
