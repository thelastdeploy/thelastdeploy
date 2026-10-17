#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Expands Logical Volume and Filesystem
# Lab: lnx-expand-logical-volume
# ==============================================================================

# Step 1: Ensure resize-test directory exists
student_exec \
  --step-name "Ensure resize-test directory exists" \
  --cmd "mkdir -p ~/resize-test" \
  --expect-exit-code 0

# Step 2: Write summary line to expand_summary.txt
student_exec \
  --step-name "Write LV expansion summary" \
  --cmd "echo 'LV_EXPAND_SYNTAX_VERIFIED' > ~/resize-test/expand_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of expand_summary.txt
student_exec \
  --step-name "Verify expand_summary.txt content" \
  --cmd "cat ~/resize-test/expand_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LV_EXPAND_SYNTAX_VERIFIED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Logical volume expansion verified."
