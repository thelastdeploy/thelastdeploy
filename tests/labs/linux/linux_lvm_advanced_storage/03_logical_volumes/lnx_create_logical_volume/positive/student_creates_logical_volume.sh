#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Logical Volumes
# Lab: lnx-create-logical-volume
# ==============================================================================

# Step 1: Ensure lv-test directory exists
student_exec \
  --step-name "Ensure lv-test directory exists" \
  --cmd "mkdir -p ~/lv-test" \
  --expect-exit-code 0

# Step 2: Write summary line to lv_info.txt
student_exec \
  --step-name "Write LV creation syntax summary" \
  --cmd "echo 'LV_CREATE_SYNTAX_VERIFIED' > ~/lv-test/lv_info.txt" \
  --expect-exit-code 0

# Step 3: Verify content of lv_info.txt
student_exec \
  --step-name "Verify lv_info.txt content" \
  --cmd "cat ~/lv-test/lv_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LV_CREATE_SYNTAX_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Logical volume creation syntax verified."
