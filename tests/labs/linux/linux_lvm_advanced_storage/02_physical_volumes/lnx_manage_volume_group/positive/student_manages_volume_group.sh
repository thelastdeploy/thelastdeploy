#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Volume Groups
# Lab: lnx-manage-volume-group
# ==============================================================================

# Step 1: Ensure pv-test directory exists
student_exec \
  --step-name "Ensure pv-test directory exists" \
  --cmd "mkdir -p ~/pv-test" \
  --expect-exit-code 0

# Step 2: Write summary line to vg_info.txt
student_exec \
  --step-name "Write volume group management summary" \
  --cmd "echo 'VG_MANAGEMENT_VERIFIED' > ~/pv-test/vg_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of vg_info.txt
student_exec \
  --step-name "Verify vg_info.txt content" \
  --cmd "cat ~/pv-test/vg_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "VG_MANAGEMENT_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Volume group management verified."
